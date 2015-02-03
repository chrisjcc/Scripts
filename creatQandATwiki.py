#!/usr/bin/env python
import os #.path
import sys
import argparse

usage = 'usage: %prog.py [-options] arg1 arg2 ...'
parser = argparse.ArgumentParser(description=usage)

parser.add_argument('--version', '-v',         action='version',   version='%(prog)s 1.0')
parser.add_argument('--file',    '-f',         dest='filename',    help='write report to FILE', metavar="FILE")
parser.add_argument('-q',        '--quiet',    dest='verbose',     action='store_false', default=True,  help='don\'t print status messages to stdout')
parser.add_argument('-c',        '--create',   dest='createTwiki', action='store_true',  default=False, help='creating twiki')
parser.add_argument('-r',        '--response', dest='response',    action='store_true',  default=True, help='comment')

args = parser.parse_args()

# List of variables
analysisTitle = "Search for anomalous production with multilepton final states in pp collisions with &#8730;s = 8 TeV at CMS"
abstract = "A search for anomalous production..."
Committee = "ARC"
cadiNumberAN = "AN2015_137_v10"
cadiNumberPAS = "SUS-15-001"
cmsURLPath = "cms-physics/public"
dateOfComment = "Month. Day, Year"
comment = "The PAS is in very good shape. I just noticed a few things that need clearing up which I have listed below.\
\n Regards,\
\n Name of person"

# Twiki header: Includes twiki tags for latex syntax and repsonse color scheme
if args.createTwiki:

    print "\n<script type=\"text/x-mathjax-config\">MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});</script> <script type=\"text/javascript\" src=\"/twiki/pub/TWiki/MathJax/mathjax-MathJax-727332c/MathJax.js?config=TeX-AMS-MML_HTMLorMML\"></script>"
    print "\n *NOTE:* Questions are in %RED% *Red* %ENDCOLOR% (Unanswered), or %GREEN% *Green* %ENDCOLOR% (Answered), or %PURPLE% *Purple* %ENDCOLOR% (In Progress) while answers are in %BLUE% *Blue* %ENDCOLOR%. \n"

    # Twiki header: Includes twiki header tags and committe response format convention
    print "\n---+!!"+analysisTitle
    print "\n%TOC%"
    print "\n---++ Abstract"
    print "\n"+abstract
    print "---++ Further information: Link to "+cadiNumberPAS+" CADI \n"

    print "[[http://cms.cern.ch/iCMS/jsp/openfile.jsp?tp=draft&files="+cadiNumberAN+".pdf][Link to "+cadiNumberAN+" in ICMS]] \n"
    print "[[http://cms-physics.web.cern.ch/"+cmsURLPath+"/"+cadiNumberPAS+"-pas.pdf][Link to "+cadiNumberPAS+" PAS in CADI ]] \n"
    
    print "\n---++ Questions from "+Committee+" Review"
    print "<button class=\"twistyExpandAll twikiButton\">Expand all</button> <button class=\"twistyCollapseAll twikiButton\">Collapse all</button> \n"
    print "---++  "+Committee+" ("+dateOfComment+") \n"
    print "%TWISTY{mode=\"div\" showlink=\"Show Details\" hidelink=\"Hide Details\" firststart=\"hide\" showimgright=\"%ICONURLPATH{toggleopen-small}%\" hideimgright=\"%ICONURLPATH{toggleclose-small}%\"}% \n"
    
    print "*** Discussion title: Review of "+cadiNumberPAS
    print "\n"+comment
    print "\n%ENDTWISTY%"
    print "---------------------"


# Question and answer for review comments
if args.response:
    if not os.path.exists(args.filename):
        print "File does not exist!"

    else:
        print "%TWISTY{mode=\"div\" showlink=\"Show Details \" hidelink=\"Hide Details \" firststart=\"hide\" showimgright=\"%ICONURLPATH{toggleopen-small}%\" hideimgright=\"%ICONURLPATH{toggleclose-small}%\"}%\n"        

        file = open(args.filename, 'r');
        count = 1

        for line in  file.read().split('\n\n'):

            print "%RED%"+str(count)+") "+line+"%ENDCOLOR%\n"
            print "%BLUE%  %ENDCOLOR%\n"
            count = count+1

        print "%ENDTWISTY%"
        print "---------------------"
        file.close()
