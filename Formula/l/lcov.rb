class Lcov < Formula
  desc "Graphical front-end for GCC's coverage testing tool (gcov)"
  homepage "https:github.comlinux-test-projectlcov"
  url "https:github.comlinux-test-projectlcovreleasesdownloadv2.3.1lcov-2.3.1.tar.gz"
  sha256 "b3017679472d5fcca727254493d0eb44253c564c2c8384f86965ba9c90116704"
  license "GPL-2.0-or-later"
  head "https:github.comlinux-test-projectlcov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcedc02edaf2f1741c7dba360cc56e57804bf0c004c42e4d6c52978cccdeb741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6384fc41ccaeec619e775f181d0ca1563b392a47a9f757ab823d612ed3f449b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e6dc5a8c51db813d1c8384b244b889dba77bcace71887d3a59058fea5de0f39"
    sha256 cellar: :any_skip_relocation, sonoma:        "09faa3e1fbcd6f505f10ef0b3c26ad1560dfb277f376083f9098fe4d058742af"
    sha256 cellar: :any_skip_relocation, ventura:       "50ac9094176effcd564bbbe34000a9b96f60d6b55666dbe0350fdc26f3c094f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5927d4b4e3665b83bfcec3f33325d96fc4987ce7dd35ba830c1d5e9970a4001b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b5a406c9e0e4dffd1a92e34b1c2aee555dcdcafeff8c2ccbdcdab88897399b1"
  end

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_linux do
    resource "Capture::Tiny" do
      url "https:cpan.metacpan.orgauthorsidDDADAGOLDENCapture-Tiny-0.48.tar.gz"
      sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
    end

    resource "Specio::Exporter" do
      url "https:cpan.metacpan.orgauthorsidDDRDROLSKYSpecio-0.48.tar.gz"
      sha256 "0c85793580f1274ef08173079131d101f77b22accea7afa8255202f0811682b2"
    end

    resource "File::ShareDir::Install" do
      url "https:cpan.metacpan.orgauthorsidEETETHERFile-ShareDir-Install-0.14.tar.gz"
      sha256 "8f9533b198f2d4a9a5288cbc7d224f7679ad05a7a8573745599789428bc5aea0"
    end

    resource "DateTime" do
      url "https:cpan.metacpan.orgauthorsidDDRDROLSKYDateTime-1.65.tar.gz"
      sha256 "0bfda7ff0253fb3d88cf4bdb5a14afb8cea24d147975d5bdf3c88b40e7ab140e"
    end

    resource "DateTime::Locale" do
      url "https:cpan.metacpan.orgauthorsidDDRDROLSKYDateTime-Locale-1.42.tar.gz"
      sha256 "7d8a138fa32faf24af30a1dbdee4dd11988ddb6a129138004d220b6cc4053cb0"
    end

    resource "DateTime::TimeZone" do
      url "https:cpan.metacpan.orgauthorsidDDRDROLSKYDateTime-TimeZone-2.62.tar.gz"
      sha256 "6214f9c9c8dfa2000bae912ef2b8ebc5b163a83a0b5b2a82705162dad63466fa"
    end

    resource "namespace::autoclean" do
      url "https:cpan.metacpan.orgauthorsidEETETHERnamespace-autoclean-0.29.tar.gz"
      sha256 "45ebd8e64a54a86f88d8e01ae55212967c8aa8fed57e814085def7608ac65804"
    end

    resource "namespace::clean" do
      url "https:cpan.metacpan.orgauthorsidRRIRIBASUSHInamespace-clean-0.27.tar.gz"
      sha256 "8a10a83c3e183dc78f9e7b7aa4d09b47c11fb4e7d3a33b9a12912fd22e31af9d"
    end

    resource "B::Hooks::EndOfScope" do
      url "https:cpan.metacpan.orgauthorsidEETETHERB-Hooks-EndOfScope-0.28.tar.gz"
      sha256 "edac77a17fc36620c8324cc194ce1fad2f02e9fcbe72d08ad0b2c47f0c7fd8ef"
    end

    resource "Module::Implementation" do
      url "https:cpan.metacpan.orgauthorsidDDRDROLSKYModule-Implementation-0.09.tar.gz"
      sha256 "c15f1a12f0c2130c9efff3c2e1afe5887b08ccd033bd132186d1e7d5087fd66d"
    end

    resource "Module::Runtime" do
      url "https:cpan.metacpan.orgauthorsidZZEZEFRAMModule-Runtime-0.016.tar.gz"
      sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
    end

    resource "Try::Tiny" do
      url "https:cpan.metacpan.orgauthorsidEETETHERTry-Tiny-0.31.tar.gz"
      sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
    end

    resource "Variable::Magic" do
      url "https:cpan.metacpan.orgauthorsidVVPVPITVariable-Magic-0.64.tar.gz"
      sha256 "9f7853249c9ea3b4df92fb6b790c03a60680fc029f44c8bf9894dccf019516bd"
    end

    resource "Sub::Exporter::Progressive" do
      url "https:cpan.metacpan.orgauthorsidFFRFREWSub-Exporter-Progressive-0.001013.tar.gz"
      sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
    end

    resource "Package::Stash" do
      url "https:cpan.metacpan.orgauthorsidEETETHERPackage-Stash-0.40.tar.gz"
      sha256 "5a9722c6d9cb29ee133e5f7b08a5362762a0b5633ff5170642a5b0686e95e066"
    end

    resource "Module::Build" do
      url "https:cpan.metacpan.orgauthorsidLLELEONTModule-Build-0.4234.tar.gz"
      sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
    end

    resource "Params::Validate" do
      url "https:cpan.metacpan.orgauthorsidDDRDROLSKYParams-Validate-1.31.tar.gz"
      sha256 "1bf2518ef2c4869f91590e219f545c8ef12ed53cf313e0eb5704adf7f1b2961e"
    end

    resource "Sub::Identify" do
      url "https:cpan.metacpan.orgauthorsidRRGRGARCIASub-Identify-0.14.tar.gz"
      sha256 "068d272086514dd1e842b6a40b1bedbafee63900e5b08890ef6700039defad6f"
    end

    resource "Class::Singleton" do
      url "https:cpan.metacpan.orgauthorsidSSHSHAYClass-Singleton-1.6.tar.gz"
      sha256 "27ba13f0d9512929166bbd8c9ef95d90d630fc80f0c9a1b7458891055e9282a4"
    end

    resource "MRO::Compat" do
      url "https:cpan.metacpan.orgauthorsidHHAHAARGMRO-Compat-0.15.tar.gz"
      sha256 "0d4535f88e43babd84ab604866215fc4d04398bd4db7b21852d4a31b1c15ef61"
    end

    resource "Role::Tiny" do
      url "https:cpan.metacpan.orgauthorsidHHAHAARGRole-Tiny-2.002004.tar.gz"
      sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
    end

    resource "Eval::Closure" do
      url "https:cpan.metacpan.orgauthorsidDDODOYEval-Closure-0.14.tar.gz"
      sha256 "ea0944f2f5ec98d895bef6d503e6e4a376fea6383a6bc64c7670d46ff2218cad"
    end

    resource "Devel::StackTrace" do
      url "https:cpan.metacpan.orgauthorsidDDRDROLSKYDevel-StackTrace-2.05.tar.gz"
      sha256 "63cb6196e986a7e578c4d28b3c780e7194835bfc78b68eeb8f00599d4444888c"
    end

    resource "Params::ValidationCompiler" do
      url "https:cpan.metacpan.orgauthorsidDDRDROLSKYParams-ValidationCompiler-0.31.tar.gz"
      sha256 "7b6497173f1b6adb29f5d51d8cf9ec36d2f1219412b4b2410e9d77a901e84a6d"
    end

    resource "Exception::Class" do
      url "https:cpan.metacpan.orgauthorsidDDRDROLSKYException-Class-1.45.tar.gz"
      sha256 "5482a77ef027ca1f9f39e1f48c558356e954936fc8fbbdee6c811c512701b249"
    end

    resource "Class::Data::Inheritable" do
      url "https:cpan.metacpan.orgauthorsidRRSRSHERERClass-Data-Inheritable-0.09.tar.gz"
      sha256 "44088d6e90712e187b8a5b050ca5b1c70efe2baa32ae123e9bd8f59f29f06e4d"
    end

    resource "File::ShareDir" do
      url "https:cpan.metacpan.orgauthorsidRREREHSACKFile-ShareDir-1.118.tar.gz"
      sha256 "3bb2a20ba35df958dc0a4f2306fc05d903d8b8c4de3c8beefce17739d281c958"
    end

    resource "Class::Inspector" do
      url "https:cpan.metacpan.orgauthorsidPPLPLICEASEClass-Inspector-1.36.tar.gz"
      sha256 "cc295d23a472687c24489d58226ead23b9fdc2588e522f0b5f0747741700694e"
    end
  end

  resource "JSON" do
    url "https:cpan.metacpan.orgauthorsidIISISHIGAKIJSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
  end

  resource "PerlIO::gzip" do
    url "https:cpan.metacpan.orgauthorsidNNWNWCLARKPerlIO-gzip-0.20.tar.gz"
    sha256 "4848679a3f201e3f3b0c5f6f9526e602af52923ffa471a2a3657db786bd3bdc5"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"

    resources.each do |r|
      r.stage do
        if File.exist? "Makefile.PL"
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system ".Build"
          system ".Build", "install"
        end
      end
    end

    system "make", "PREFIX=#{prefix}", "install"
    bin.env_script_all_files(libexec"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    (testpath"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("hello world");
        return 0;
      }
    C

    system ENV.cc, "-g", "-O2", "--coverage", "-o", "hello", "hello.c"
    system ".hello"
    system bin"lcov", "--gcov-tool", "gcov", "--directory", ".", "--capture", "--output-file", "all_coverage.info"

    assert_path_exists testpath"all_coverage.info"
    assert_includes (testpath"all_coverage.info").read, testpath"hello.c"
  end
end