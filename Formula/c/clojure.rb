class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https:clojure.org"
  url "https:github.comclojurebrew-installreleasesdownload1.12.0.1495clojure-tools-1.12.0.1495.tar.gz"
  mirror "https:download.clojure.orginstallclojure-tools-1.12.0.1495.tar.gz"
  sha256 "18cc13f87c74ec4f177bd83c4416d9ec2bb9142860db06055af7598e1b82949c"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https:raw.githubusercontent.comclojurehomebrew-toolsmasterFormulaclojure.rb"
    regex(url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22ce76aee9f9a8f1e4416f75daaf1a5cafd0857432e7732b4a778736c8ad4ffb"
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