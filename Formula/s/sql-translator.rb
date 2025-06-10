class SqlTranslator < Formula
  desc "Manipulate structured data definitions (SQL and more)"
  homepage "https:github.comdbsrgitssql-translator"
  url "https:cpan.metacpan.orgauthorsidIILILMARISQL-Translator-1.62.tar.gz"
  sha256 "0acd4ff9ac3a2f8d5d67199aac02cdc127e03888e479c51c7bbdc21b85c1ce24"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd6884ab19aeeb5423ef3df3fa1cd27f1168385cc20e6698b29de481e38ed4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd6884ab19aeeb5423ef3df3fa1cd27f1168385cc20e6698b29de481e38ed4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71f7b2c9530c2e5aa5485d59994e1c02496e4089f259a3a2b7fda64d77609749"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b1a1fecd8bbbf18e8b569021cf91917b4bd0e9247798433bbde8e7a1d43285c"
    sha256 cellar: :any_skip_relocation, ventura:       "8cfcf2ebb680afcd5e2c0ebd8bba4e5e11b70c3e9aa77463822b489c256494cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4294a929fd355f853e0d4f11892902b6e9b38f0891849f85e02a22a0cb4c6c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad013b468ccc8eb007b96d2fd66ca07c3cb67448bf4134d954174945f3be5af"
  end

  uses_from_macos "perl"

  on_linux do
    resource "Moo" do
      url "https:cpan.metacpan.orgauthorsidHHAHAARGMoo-2.003006.tar.gz"
      sha256 "bcb2092ab18a45005b5e2e84465ebf3a4999d8e82a43a09f5a94d859ae7f2472"
    end

    resource "Module::Runtime" do
      url "https:cpan.metacpan.orgauthorsidZZEZEFRAMModule-Runtime-0.016.tar.gz"
      sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
    end

    resource "Sub::Quote" do
      url "https:cpan.metacpan.orgauthorsidHHAHAARGSub-Quote-2.006006.tar.gz"
      sha256 "6e4e2af42388fa6d2609e0e82417de7cc6be47223f576592c656c73c7524d89d"
    end

    resource "Try::Tiny" do
      url "https:cpan.metacpan.orgauthorsidEETETHERTry-Tiny-0.30.tar.gz"
      sha256 "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b"
    end

    resource "Import::Into" do
      url "https:cpan.metacpan.orgauthorsidHHAHAARGImport-Into-1.002005.tar.gz"
      sha256 "bd9e77a3fb662b40b43b18d3280cd352edf9fad8d94283e518181cc1ce9f0567"
    end

    resource "Role::Tiny" do
      url "https:cpan.metacpan.orgauthorsidHHAHAARGRole-Tiny-2.001004.tar.gz"
      sha256 "92ba5712850a74102c93c942eb6e7f62f7a4f8f483734ed289d08b324c281687"
    end

    resource "Class::Method::Modifiers" do
      url "https:cpan.metacpan.orgauthorsidEETETHERClass-Method-Modifiers-2.13.tar.gz"
      sha256 "ab5807f71018a842de6b7a4826d6c1f24b8d5b09fcce5005a3309cf6ea40fd63"
    end

    resource "DBI" do
      url "https:cpan.metacpan.orgauthorsidTTITIMBDBI-1.643.tar.gz"
      sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
    end

    resource "Carp::Clan" do
      url "https:cpan.metacpan.orgauthorsidEETETHERCarp-Clan-6.08.tar.gz"
      sha256 "c75f92e34422cc5a65ab05d155842b701452434e9aefb649d6e2289c47ef6708"
    end

    resource "Parse::RecDescent" do
      url "https:cpan.metacpan.orgauthorsidJJTJTBRAUNParse-RecDescent-1.967015.tar.gz"
      sha256 "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37"
    end
  end

  resource "File::ShareDir::Install" do
    url "https:cpan.metacpan.orgauthorsidEETETHERFile-ShareDir-Install-0.13.tar.gz"
    sha256 "45befdf0d95cbefe7c25a1daf293d85f780d6d2576146546e6828aad26e580f9"
  end

  resource "Package::Variant" do
    url "https:cpan.metacpan.orgauthorsidMMSMSTROUTPackage-Variant-1.003002.tar.gz"
    sha256 "b2ed849d2f4cdd66467512daa3f143266d6df810c5fae9175b252c57bc1536dc"
  end

  resource "strictures" do
    url "https:cpan.metacpan.orgauthorsidHHAHAARGstrictures-2.000006.tar.gz"
    sha256 "09d57974a6d1b2380c802870fed471108f51170da81458e2751859f2714f8d57"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "--defaultdeps",
                                  "INSTALL_BASE=#{libexec}",
                                  "INSTALLSITESCRIPT=#{bin}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make", "install"

    bin.env_script_all_files libexec"bin", PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    command = "#{bin}sqlt -f MySQL -t PostgreSQL --no-comments -"
    sql_input = "create table sqlt ( id int AUTO_INCREMENT );"
    sql_output = <<~SQL
      CREATE TABLE "sqlt" (
        "id" serial
      );

    SQL
    assert_equal sql_output, pipe_output(command, sql_input)
  end
end