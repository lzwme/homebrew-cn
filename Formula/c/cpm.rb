class Cpm < Formula
  desc "Fast CPAN module installer"
  homepage "https:metacpan.orgpodcpm"
  url "https:cpan.metacpan.orgauthorsidSSKSKAJIApp-cpm-0.997015.tar.gz"
  sha256 "623f8c67287d864b5fb1cd9c70aaa2a31c82c245cc80d01ff01e166f4cdd4ffc"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https:github.comskajicpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6ce5c02fb9774f5fb5e0b60261e37fc52d81de52fc6a4e8c0f8c55c9327879a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6ce5c02fb9774f5fb5e0b60261e37fc52d81de52fc6a4e8c0f8c55c9327879a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6ce5c02fb9774f5fb5e0b60261e37fc52d81de52fc6a4e8c0f8c55c9327879a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f58e1433474e13b991548855ba4e5390112de573ddb983e3c22ed30c140b0f1f"
    sha256 cellar: :any_skip_relocation, ventura:        "f58e1433474e13b991548855ba4e5390112de573ddb983e3c22ed30c140b0f1f"
    sha256 cellar: :any_skip_relocation, monterey:       "f58e1433474e13b991548855ba4e5390112de573ddb983e3c22ed30c140b0f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c3f4a427bb14713cb10039cf64352524e294f7dbcdb70c935a3fd824884c17"
  end

  depends_on "perl"

  resource "Module::Build::Tiny" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTModule-Build-Tiny-0.047.tar.gz"
    sha256 "71260e9421b93c33dd1b3e7d0cf15f759c0ca7c753fa840279ec3be70f8f8c9d"
  end

  resource "CPAN::Common::Index" do
    url "https:cpan.metacpan.orgauthorsidDDADAGOLDENCPAN-Common-Index-0.010.tar.gz"
    sha256 "c43ddbb22fd42b06118fe6357f53700fbd77f531ba3c427faafbf303cbf4eaf0"
  end

  resource "CPAN::DistnameInfo" do
    url "https:cpan.metacpan.orgauthorsidGGBGBARRCPAN-DistnameInfo-0.12.tar.gz"
    sha256 "2f24fbe9f7eeacbc269d35fc61618322fc17be499ee0cd9018f370934a9f2435"
  end

  resource "CPAN::Meta::Check" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTCPAN-Meta-Check-0.018.tar.gz"
    sha256 "f619d2df5ea0fd91c8cf83eb54acccb5e43d9e6ec1a3f727b3d0ac15d0cf378a"
  end

  resource "Capture::Tiny" do
    url "https:cpan.metacpan.orgauthorsidDDADAGOLDENCapture-Tiny-0.48.tar.gz"
    sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
  end

  resource "Class::Tiny" do
    url "https:cpan.metacpan.orgauthorsidDDADAGOLDENClass-Tiny-1.008.tar.gz"
    sha256 "ee058a63912fa1fcb9a72498f56ca421a2056dc7f9f4b67837446d6421815615"
  end

  resource "Command::Runner" do
    url "https:cpan.metacpan.orgauthorsidSSKSKAJICommand-Runner-0.200.tar.gz"
    sha256 "5ad26d06111bfecd53c8f5bb5dea94bf2025f6c78e95f6d8012e4cfa89e29f26"
  end

  resource "ExtUtils::Config" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTExtUtils-Config-0.008.tar.gz"
    sha256 "ae5104f634650dce8a79b7ed13fb59d67a39c213a6776cfdaa3ee749e62f1a8c"
  end

  resource "ExtUtils::Helpers" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTExtUtils-Helpers-0.026.tar.gz"
    sha256 "de901b6790a4557cf4ec908149e035783b125bf115eb9640feb1bc1c24c33416"
  end

  resource "ExtUtils::InstallPaths" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTExtUtils-InstallPaths-0.012.tar.gz"
    sha256 "84735e3037bab1fdffa3c2508567ad412a785c91599db3c12593a50a1dd434ed"
  end

  resource "ExtUtils::MakeMaker::CPANfile" do
    url "https:cpan.metacpan.orgauthorsidIISISHIGAKIExtUtils-MakeMaker-CPANfile-0.09.tar.gz"
    sha256 "2c077607d4b0a108569074dff76e8168659062ada3a6af78b30cca0d40f8e275"
  end

  resource "File::Copy::Recursive" do
    url "https:cpan.metacpan.orgauthorsidDDMDMUEYFile-Copy-Recursive-0.45.tar.gz"
    sha256 "d3971cf78a8345e38042b208bb7b39cb695080386af629f4a04ffd6549df1157"
  end

  resource "File::Which" do
    url "https:cpan.metacpan.orgauthorsidPPLPLICEASEFile-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end

  resource "File::pushd" do
    url "https:cpan.metacpan.orgauthorsidDDADAGOLDENFile-pushd-1.016.tar.gz"
    sha256 "d73a7f09442983b098260df3df7a832a5f660773a313ca273fa8b56665f97cdc"
  end

  resource "HTTP::Tinyish" do
    url "https:cpan.metacpan.orgauthorsidMMIMIYAGAWAHTTP-Tinyish-0.18.tar.gz"
    sha256 "80380b8d33c6bfa96bb0104fa6a41c27dcc4e9c83a48df1fad39097f5fdcfde5"
  end

  resource "IPC::Run3" do
    url "https:cpan.metacpan.orgauthorsidRRJRJBSIPC-Run3-0.048.tar.gz"
    sha256 "3d81c3cc1b5cff69cca9361e2c6e38df0352251ae7b41e2ff3febc850e463565"
  end

  resource "Menlo" do
    url "https:cpan.metacpan.orgauthorsidMMIMIYAGAWAMenlo-1.9019.tar.gz"
    sha256 "3b573f68e7b3a36a87c860be258599330fac248b518854dfb5657ac483dca565"
  end

  resource "Menlo::Legacy" do
    url "https:cpan.metacpan.orgauthorsidMMIMIYAGAWAMenlo-Legacy-1.9022.tar.gz"
    sha256 "a6acac3fee318a804b439de54acbc7c27f0b44cfdad8551bbc9cd45986abc201"
  end

  resource "Module::CPANfile" do
    url "https:cpan.metacpan.orgauthorsidMMIMIYAGAWAModule-CPANfile-1.1004.tar.gz"
    sha256 "88efbe2e9a642dceaa186430fedfcf999aaf0e06f6cced28a714b8e56b514921"
  end

  resource "Module::cpmfile" do
    url "https:cpan.metacpan.orgauthorsidSSKSKAJIModule-cpmfile-0.006.tar.gz"
    sha256 "1bc976e2937724896c9f6eae9e5dca981e27f98430b92de270ee3514fd00ac0f"
  end

  resource "Parallel::Pipes" do
    url "https:cpan.metacpan.orgauthorsidSSKSKAJIParallel-Pipes-0.200.tar.gz"
    sha256 "88b9850eacc9d618f3e91a51caa386c4a64e82cc187350335244e349b8111106"
  end

  resource "Parse::PMFile" do
    url "https:cpan.metacpan.orgauthorsidIISISHIGAKIParse-PMFile-0.44.tar.gz"
    sha256 "e08f0f56455b3ac12dccd8c711650612b7d3cd150f8a6f8ae6b43b2da47df994"
  end

  resource "String::ShellQuote" do
    url "https:cpan.metacpan.orgauthorsidRROROSCHString-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "Tie::Handle::Offset" do
    url "https:cpan.metacpan.orgauthorsidDDADAGOLDENTie-Handle-Offset-0.004.tar.gz"
    sha256 "ee9f39055dc695aa244a252f56ffd37f8be07209b337ad387824721206d2a89e"
  end

  resource "URI" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSURI-5.21.tar.gz"
    sha256 "96265860cd61bde16e8415dcfbf108056de162caa0ac37f81eb695c9d2e0ab77"
  end

  resource "Win32::ShellQuote" do
    url "https:cpan.metacpan.orgauthorsidHHAHAARGWin32-ShellQuote-0.003001.tar.gz"
    sha256 "aa74b0e3dc2d41cd63f62f853e521ffd76b8d823479a2619e22edb4049b4c0dc"
  end

  resource "YAML::PP" do
    url "https:cpan.metacpan.orgauthorsidTTITINITAYAML-PP-v0.37.0.tar.gz"
    sha256 "9c4cb4e8801a69b44440c0dbcc40e6b6f0646f2016a5f30877aadef6b28071ad"
  end

  resource "local::lib" do
    url "https:cpan.metacpan.orgauthorsidHHAHAARGlocal-lib-2.000029.tar.gz"
    sha256 "8df87a10c14c8e909c5b47c5701e4b8187d519e5251e87c80709b02bb33efdd7"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"

    build_pl = [
      "Module::Build::Tiny",
      "Module::cpmfile",
      "Command::Runner",
      "Parallel::Pipes",
    ]

    resources.each do |r|
      r.stage do
        next if build_pl.include? r.name

        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    build_pl.each do |name|
      resource(name).stage do
        system "perl", "Build.PL", "--install_base", libexec
        system ".Build"
        system ".Build", "install"
      end
    end

    system "perl", "Build.PL", "--install_base", libexec
    system ".Build"
    system ".Build", "install"

    (bin"cpm").write_env_script("#{libexec}bincpm", PERL5LIB: ENV["PERL5LIB"])
    man1.install_symlink libexec"manman1cpm.1"
    man3.install_symlink Dir[libexec"manman3App::cpm*"].reject { |f| File.empty?(f) }
  end

  test do
    system bin"cpm", "install", "Perl::Tutorial"

    expected = <<~EOS
      NAME
          Perl::Tutorial::HelloWorld - Hello World for Perl

      SYNOPSIS
            #!usrbinperl
            #
            # The traditional first program.

            # Strict and warnings are recommended.
            use strict;
            use warnings;

            # Print a message.
            print "Hello, World!\\n";
    EOS
    assert_match expected,
                 shell_output("PERL5LIB=locallibperl5 perldoc Perl::Tutorial::HelloWorld")
  end
end