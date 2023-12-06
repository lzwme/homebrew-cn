class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://ghproxy.com/https://github.com/clojure/brew-install/releases/download/1.11.1.1429/clojure-tools-1.11.1.1429.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.11.1.1429.tar.gz"
  sha256 "a2fdecd6a3c61df3c600fb60c00a8f1be854e91e6718c03bb9c83c415a6ab82e"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://ghproxy.com/https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e36d3a33a7f278cc0af03edbdaf33397fde6b59f72e9f3f161208fe0e8eb0df"
  end

  depends_on "openjdk"
  depends_on "rlwrap"

  uses_from_macos "ruby" => :build

  def install
    system "./install.sh", prefix
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    ENV["TERM"] = "xterm"
    system("#{bin}/clj", "-e", "nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}/#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end