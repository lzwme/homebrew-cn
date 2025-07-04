class Yydecode < Formula
  desc "Decode yEnc archives"
  homepage "https://yydecode.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/yydecode/yydecode/0.2.10/yydecode-0.2.10.tar.gz"
  sha256 "bd4879643f6539770fd23d1a51dc6a91ba3de2823cf14d047a40c630b3c7ba66"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b24e0faa262eecd027d92d536e2975069785ddbb69be173b74091903c6066af2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1194156e2ec7b87746123e20fc848784605d1270e8764d9868a35dd7bea55e99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f42ef32de3ecc81a603e7b8643a321bcf7af9f564224756d8544479b2df6be7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2b69a15d8d9928ae09b77b310408111186ee22fea50ce4d06a563f1b61cb1fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83fcf98a8fbf68bf2ce8c5847b53730856f65f8139bda8506a912e4650020e8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef2573d29ca6a691e1fc860b765b08c0955d1be74ab29bf63dba51f62860f30c"
    sha256 cellar: :any_skip_relocation, ventura:        "0874c4fcf0259dbb8ee3fa756cd77f1ddd4a777d66b9bdef00591749bb791298"
    sha256 cellar: :any_skip_relocation, monterey:       "851194515f4b14bdcd0c7e2849b1e8f68222e9fd90494ae16281b9967355ff1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4700a77bb5b4bbce8b34f92662661cf13f9560c1637256fd8dc9581ec7caf077"
    sha256 cellar: :any_skip_relocation, catalina:       "206152a71458e053c332c7ca52f6db716b146e993c08384afb98e56a43c043b6"
    sha256 cellar: :any_skip_relocation, mojave:         "18d815befe31bcdeaac8edff43cb878f53c34a608fa946c13a14143139bf887a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e2e7285f1f2b18b4b99800602d15932dba435f6480c5776e5b57b734727f652f"
    sha256 cellar: :any_skip_relocation, sierra:         "91dc4fe34931d45fcebaead39ce505116322c7866e786cf86a7065f9e57b42ac"
    sha256 cellar: :any_skip_relocation, el_capitan:     "07aa31cabc4f2533df3b5670beed1ba99e3e7dcc3ffb3cf55fff56866e7bf11e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8ce7595e4ff21d9847be7d4ed031f11144a86dc19222edcbad7a1539ba1e8e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bc48318a8c556b45209f4c7a8bb41c638767ba44166f219f8cc67b94b7be8a2"
  end

  def install
    # Redefinition of type found in 10.13 system headers
    # https://sourceforge.net/p/yydecode/bugs/5/
    inreplace "src/crc32.h", "typedef unsigned long int u_int32_t;", "" if DevelopmentTools.clang_build_version >= 900

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end