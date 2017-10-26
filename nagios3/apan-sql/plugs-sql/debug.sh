
debug() {
	if [ $DEBUG ]; then
		echo "`date` $*" >> ${DEBUGFILE}
	fi
}

cgidebug() {
	if [ $CGIDEBUG ]; then
	echo "`date` $*" >> ${CGIDEBUGFILE}
	fi
}

