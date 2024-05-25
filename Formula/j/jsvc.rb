class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https:commons.apache.orgdaemonjsvc.html"
  url "https:www.apache.orgdyncloser.lua?path=commonsdaemonsourcecommons-daemon-1.4.0-src.tar.gz"
  mirror "https:archive.apache.orgdistcommonsdaemonsourcecommons-daemon-1.4.0-src.tar.gz"
  sha256 "0059f1e80aa639f02c7e1ff800b57dc62036a5b3f4b17d61e5d3e3ffd2428fee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa154bb18167635e5bf59f06968ad2f795bcb819c9250b4f431d78778c8417da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc8cc85b87a73647c42a9fbc15e762f0053274b4d221a5e44ef14cd79b723a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0b5125b0a7f2f0c65b70c9cfcaf360046a2edbd99969a78d2689df02cb7f03d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b42f73ea5fec143f1451ee941f27accc500311c91ef08a71d976265e534cff7"
    sha256 cellar: :any_skip_relocation, ventura:        "8aafeea24d7f1c27b5e73f94428049896c4258ea392a79984c994c4da72452f5"
    sha256 cellar: :any_skip_relocation, monterey:       "b68e62120116e03619e77496c1cd5b3140a8520002688c3ec8a8401d5e04a7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78e7084642c481492d64a4f30ff92bab922dfb3c62875569b3caa28fb1e07039"
  end

  depends_on "openjdk"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "srcnativeunix" do
      # https:github.comHomebrewhomebrew-corepull168294#issuecomment-2104388230
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

      system ".configure", "--with-java=#{Formula["openjdk"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin"jsvc").write_env_script libexec"jsvc", Language::Java.overridable_java_home_env
    end
  end

  test do
    output = shell_output("#{bin}jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end