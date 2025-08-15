class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://ghfast.top/https://github.com/clojure/brew-install/releases/download/1.12.1.1561/clojure-tools-1.12.1.1561.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.12.1.1561.tar.gz"
  sha256 "fbb8457f64bf33cc8caaf7be77c4630a828167447777a809a9aae587d535075f"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d3259faeecd2d39de7ae215777ad0915294b218c6404a52452104bbcfdf96fcc"
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