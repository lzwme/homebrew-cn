class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://ghfast.top/https://github.com/clojure/brew-install/releases/download/1.12.4.1607/clojure-tools-1.12.4.1607.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.12.4.1607.tar.gz"
  sha256 "57024e5cdd288a3f13ec9c7be481dbc502e4cf329ed93fe34d8729d6271975c9"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8bcc92ac686a5070bb2c39bc5646f7483d4f5186b81eac8a17209e5adf6523a"
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