class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://ghfast.top/https://github.com/clojure/brew-install/releases/download/1.12.4.1612/clojure-tools-1.12.4.1612.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.12.4.1612.tar.gz"
  sha256 "584c7256bccb0db69f91d5eea0a78c7ec22bdf34e28ed7aeeaab1c60eb9ac85f"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1d147a1be9751f59173999750ad4e3a52882a81f7a781f054d5c50e9b94b5e4c"
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