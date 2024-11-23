class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https:clojure.org"
  url "https:github.comclojurebrew-installreleasesdownload1.12.0.1488clojure-tools-1.12.0.1488.tar.gz"
  mirror "https:download.clojure.orginstallclojure-tools-1.12.0.1488.tar.gz"
  sha256 "bc19be0010bef0421c26fd3bec7bc3bca08c192828d59a151845422dc4420742"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https:raw.githubusercontent.comclojurehomebrew-toolsmasterFormulaclojure.rb"
    regex(url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "670da050953b161d4a1316b8d10e91a594ec2afd4767803382deb7ca1231de6b"
  end

  depends_on "openjdk"
  depends_on "rlwrap"

  uses_from_macos "ruby" => :build

  def install
    system ".install.sh", prefix
    bin.env_script_all_files libexec"bin", Language::Java.overridable_java_home_env
  end

  test do
    ENV["TERM"] = "xterm"
    system("#{bin}clj", "-e", "nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end