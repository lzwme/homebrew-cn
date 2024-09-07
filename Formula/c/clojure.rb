class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https:clojure.org"
  url "https:github.comclojurebrew-installreleasesdownload1.12.0.1479clojure-tools-1.12.0.1479.tar.gz"
  mirror "https:download.clojure.orginstallclojure-tools-1.12.0.1479.tar.gz"
  sha256 "2a515c45755df1edf378fdfafb380251c7736de2db15f7dbe55ed7295f0d296c"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https:raw.githubusercontent.comclojurehomebrew-toolsmasterFormulaclojure.rb"
    regex(url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28f862cef35191524e9cabcb23e7d90dc93464ccf460fec08a57dae669d840e7"
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