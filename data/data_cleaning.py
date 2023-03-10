import pandas as pd
import numpy as np

df = pd.read_csv('./vgsales.csv', parse_dates=['Year'])

#need to:
	#remove rows with year 2017 and 2020
	#group platform by company, with 'other' category (PC, playstation, xbox, nintendo, sega, (atari), other)
	#group publisher to have 'other' category (8 categories ish)


#grouping platform
#groups
playstation = ['PS', 'PS2', 'PS3', 'PS4', 'PSP', 'PSV']
xbox = ['X360', 'XOne', 'XB', 'XS']
nintendo_console = ['Wii', 'NES', 'SNES', 'N64', 'GC', 'FDS', 'VB', 'IQue']
nintendo_handheld = ['DS', 'NS', 'GB', 'GBA', '3DS', 'WiiU']
sega = ['GEN', 'MS', 'GG', 'SAT', 'DC', 'SCD', 'S32X']
atari = ['2600', '7800', 'Lynx', '5200', 'AJ']
other = ['TG16', 'WS', 'Int', 'NGage', '3DO', 'CV', 'CDi', 'CT', 'NG', 'PCFX', 'FCF', 'Odys', 'CD32', 'GIZ']
#print(df['Platform'].value_counts())

df['Platform_grouped'] = np.NaN

for i, value in enumerate(df['Platform']):
    if (value in playstation):
        df.loc[i, 'Platform_grouped'] = 'PlayStation'
    elif (value in xbox):
        df.loc[i, 'Platform_grouped'] = 'Xbox'
    elif (value in nintendo_console):
        df.loc[i, 'Platform_grouped'] = 'Nintendo(console)'
    elif (value in nintendo_handheld):
        df.loc[i, 'Platform_grouped'] = 'Nintendo(handheld)'
    elif (value == 'PC'):
        df.loc[i, 'Platform_grouped'] = 'Computer'
    elif (value in sega):
        df.loc[i, 'Platform_grouped'] = 'Sega'
    elif (value in atari):
        df.loc[i, 'Platform_grouped'] = 'Atari'
    elif (value in other):
        df.loc[i, 'Platform_grouped'] = 'Other'
    else:
        pass

print(df['Platform_grouped'].value_counts())





#adding handheld flag
#handheld = []





#group publisher to have 'other' category (8 categories ish)
#print(df['Publisher'].value_counts())

keep = ['Electronic Arts', 'Activision', 'Namco Bandai Games', 'Ubisoft', 'Konami Digital Entertainment', 'THQ', 'Nintendo', 'Sony Computer Entertainment', 'Sega']


df['Publisher_grouped'] = np.NaN

for i, value in enumerate(df['Publisher']):
    if (value in keep):
        df.loc[i, 'Publisher_grouped'] = value.replace(' ', '\n').splitlines()[0]

    else:
        df.loc[i, 'Publisher_grouped'] = 'Other'


print('\n\n')
print(df['Publisher_grouped'].value_counts())


#removing 2017/2020 rows
print(len(df.index))
df.drop(df[df['Year'].dt.year == 2017].index, axis=0, inplace=True)
df.reset_index(drop=True, inplace=True)
df.drop(df[df['Year'].dt.year == 2020].index, axis=0, inplace=True)
df.reset_index(drop=True, inplace=True)
print(len(df.index))



#output to csv
df.to_csv('vgsales-cleaned.csv', index = True)
