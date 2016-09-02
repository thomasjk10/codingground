/*  REXX */                                         
/*pdsname = "dv81556.SHARE.CIF.JCLLIB"*/            
   Trace r                                          
c = 1                                               
a = 1                                               
delim = ','                                         
b1= ".BKP01,"                                       
b2= "TEST"                                          
a1= "//****COPY FILES TO TEST FILES"                
a2= "//SORT1    EXEC PGM=SYS004,PARM=SORT"          
a3= "//SORTIN   DD  DISP=SHR,"                      
a4= "//SORTOUT  DD  DSN="                           
a5= "//             DCB=(*.SORTIN),"                
a6= "//             DISP=(NEW,CATLG,DELETE),"       
a7= "//             SPACE=(CYL,(500,200),RLSE)"     
a8= "//SYSIN    DD  *"                              
a9= "  SORT FIELDS=COPY"                            
a10="//*"                                 a11="//"SYSVAR(SYSUID) "JOB SYS,'FILE-BCPY-J486',"                
a12="//             CLASS=A,MSGCLASS=9, TYPRUN=HOLD,"             
a13="//             NOTIFY="SYSVAR(SYSUID)                        
a14="/*JOBPARM R=130"                                             
a15="//CA11RMS EXEC CA11RMS,PARM='F'"                             
pdsname = "TEST.DDA.REXX.PRCSTEST"                                
/*dd_out  = 'dv81556.share.dda.out' */                            
/*"ALLOCATE FI(OUTP) DS('"dd_out"') OLD" */                       
/*                                                                
firstLine = " Program Name " ||  " Total Lines" || "  exclude * " 
push firstLine                                                    
"EXECIO 1 DISKW OUTP" */                                          
address tso                                                       
y = OUTTRAP('mbrs.')                                              
"LISTDS '"pdsname"' MEMBERS"                                      
y = outtrap('OFF')                                                
say " Total number of members : " mbrs.0 - 6                      
say SYSVAR(SYSUID)                        /*TRACE('?I')*/                                            
DO xx1 = 7 TO mbrs.0                                       
   ymbr1 = STRIP(mbrs.xx1,"B")                             
   dsnName= pdsname||"("||ymbr1||")"                       
   svmbr1 = ymbr1                                          
     /* READ THE YMBR1 IN THE PDS AND SRCH FOR PGM NAME */ 
   ADDRESS TSO                                             
   "ALLOCATE FI(PMEM) DS('"dsnName"') SHR"                 
   "EXECIO * DISKR PMEM(STEM MYVAR. FINIS"                 
   "FREE FI(PMEM)"                                         
   input = "(0)"                                           
   inpzeroct = 0                                           
   arr.a = a11                                             
   a=a+1                                                   
   arr.a = a12                                             
   a=a+1                                                   
   arr.a = a13                                             
   a=a+1                                     arr.a = a14                                       
   a=a+1                                             
   arr.a = a15                                       
   a=a+1                                             
   totalLineCount = MYVAR.0                          
   read_new:                                         
      do I = 1 TO MYVAR.0                            
         inpcheck = substr(myvar.i,1,80)             
         zerPOS=POS('(0)',inpcheck)                  
         starpos=POS('//*',inpcheck)                 
         arr.c = inpcheck                            
          if c = 1 then do                           
             call process                            
             c = c +1                                
             call read_new                           
          end                                        
        /* do until i > c                            
           /*say find(arr.i,"T")*/      
       process:                                                  
        if zerPOS   >  0   then                                  
           if starpos = 0  then                                  
          do                                                     
            PARSE VALUE inpcheck with colnum ddname dsn oth      
            PARSE VALUE dsn with extr dsnx(delim)                
            len =length(dsn)                                     
            dsn1=strip(substr(dsn,5,len),b)                      
            len1=length(dsn1)                                    
            dsn2=strip(substr(dsn1,5,len1),b)                   
             len2=length(dsn2)                              
             dsn3=reverse(dsn2)                             
             dsn4=strip(substr(dsn3,5,len2))                
             dsn5=reverse(dsn4)                             
             len5=length(dsn5)                              
         /*  dsn6=reverse(strip(substr(dsn1,1,len),b))      
             dsn7=substr(dsn6,2,len1-1)                     
             dsn8=reverse(dsn7) */                          
         /*  dsn6=strip(substr(dsn5,5,len1),b) */           
         /*  len3=length(dsn6) */                           
         /*  dsn7=substr(dsn5,7,len3) */                    
             arr.a = a1                                     
             a=a+1                                          
             arr.a = a2                                     
             a=a+1                                          
             arr.a = a3 ||extr                              
             a=a+1                                          
             if substr(dsn5,5,2)= 'JT' then                 
                do                                          
           dsn6 = substr(dsn5,1,4)||'ZP'||strip(substr(dsn5,7,len5),b)
                 arr.a = a4 || b2 || dsn6 || b1                       
                 a=a+1                                                
           end                                                        
           else do                                                    
           arr.a = a4 || b2 || dsn5 || b1                             
           a=a+1                                                      
           end                                                        
           arr.a = a5                                                 
           a=a+1                                                      
           arr.a = a6                                                 
           a=a+1                                                      
           arr.a = a7                                                 
           a=a+1                                                      
           arr.a = a8                                                 
           a=a+1                                                      
           arr.a = a9                                                 
           a=a+1                                                      
           arr.a = a10                                                
             a=a+1                                                 
           end                                                     
           return                                                  
      end                                                          
    /*end*/                                                        
  /*END*/                                                          
  TEMP_FILE = "'"TEST.DV.OP.REXX.FILE"'"                           
  "DELETE" TEMP_FILE                                               
  ADDRESS TSO                                                      
 "ALLOCATE FI(OUTPUT) DA("TEMP_FILE") NEW                          
  SPACE(50 50) TRACKS DSORG(PS) BLKSIZE(0) LRECL(80) RECFM(F B)"   
  "EXECIO * DISKW OUTPUT (STEM ARR. FINIS"                         
  "FREE FILE(OUTPUT)"                                              
    SAY 'OUTPUT:'TEMP_FILE                                         
exit                                                               

