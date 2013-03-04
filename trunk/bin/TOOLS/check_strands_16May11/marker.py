# marker.py

# defines marker class and objects to work on it

class Marker:
    def __init__(self,pos,snpname):
        self.pos = pos
        self.snpname = snpname
        self.alleles = []
        self.altnames = []
        self.refAlleles = []
        self.switchNeeded = []
        self.switchAllowed = []
        self.badfiles = []
        self.goodfiles = []
        self.genotypes = {}
        self.LDcomp = {}
        
    def add_alleles(self,filenbr,a1,a2):
        self.alleles.append([filenbr,a1,a2])
        self.goodfiles.append(filenbr)
    def get_alleleList(self):
        return self.alleles
    def set_refAlleles(self,a1,a2):
        self.refAlleles = [a1,a2]
    def get_refAlleles(self):
        return self.refAlleles
    def add_altname(self,altname):
            self.altnames.append(altname)
    def get_altnames(self):
        return self.altnames
    def get_snpname(self):
        return self.snpname
    def get_pos(self):
        return self.pos
    def set_switchNeeded(self,filenbr):
        self.switchNeeded.append(filenbr)
    def needs_switch(self,filenbr):
        return filenbr in self.switchNeeded
    def set_switchAllowed(self,filenbr):
        self.switchAllowed.append(filenbr)
    def unset_switchAllowed(self,filenbr):
        self.switchAllowed.remove(filenbr)
    def allows_switch(self,filenbr):
        return filenbr in self.switchAllowed
    def add_genotypes(self,filenbr,genotype_list):
        self.genotypes[filenbr] = genotype_list
    def has_genotypes(self,filenbr):
	return (filenbr in self.genotypes)
    def get_genotypes(self,filenbr):
        return self.genotypes[filenbr]
    def set_badfile(self,filenbr):
        if filenbr in self.goodfiles:
          self.badfiles.append(filenbr)
          self.goodfiles.remove(filenbr)
    def set_all_bad(self):
        gf = self.goodfiles[:]
        for i in gf:
            self.set_badfile(i)
    def get_badfiles(self):
        return self.badfiles
    def get_goodfiles(self):
        return self.goodfiles
    def add_LDcomp(self,filenbr,good):
        if not self.LDcomp.has_key(filenbr):
            self.LDcomp[filenbr]=[0,0]
        if good:
            self.LDcomp[filenbr][0] += 1
        else:
            self.LDcomp[filenbr][1] += 1
    def add_good_LDcomp(self,filenbr):
        self.add_LDcomp(filenbr,1)
    def add_bad_LDcomp(self,filenbr):
        self.add_LDcomp(filenbr,0)
    def get_LDcomp(self):
        return self.LDcomp
    
 
    
