class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://ghfast.top/https://github.com/clojure/brew-install/releases/download/1.12.5.1645/clojure-tools-1.12.5.1645.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.12.5.1645.tar.gz"
  sha256 "4a8612e7fd725ec8e453f870b22d5bc1a68eeff774c3d79329a985f351c0b83b"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30d5f3402663cbd0d07f8e64b161a898f1c698ce5b2e400c71eb02af9f905ecc"
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