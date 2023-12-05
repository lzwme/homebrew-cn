class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://ghproxy.com/https://github.com/clojure/brew-install/releases/download/1.11.1.1420/clojure-tools-1.11.1.1420.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.11.1.1420.tar.gz"
  sha256 "afd113e9bc4df16ae233c05433cc936d9b1e649977ec84b05f6af0ade633eb51"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://ghproxy.com/https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0bc3753a5c840b002d1a8f115957c72414fe2bd9fafeac2698e156f9f875fa3f"
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