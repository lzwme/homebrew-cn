class Patchpal < Formula
  desc "AI Assisted Patch Backporting Tool Frontend"
  homepage "https://gitlab.com/patchpal-ai/patchpal-gui"
  url "https://gitlab.com/patchpal-ai/patchpal-gui/-/archive/v0.5.0/patchpal-gui-v0.5.0.tar.bz2"
  sha256 "19b726eee7c7f6f4471ca7ed0fd3aaa79bf5f196682e314b5917545244bda940"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbe61dd12f6367030dc8443302d433ee629e99d6455d93a11aa6ca82fe491c74"
    sha256 cellar: :any,                 arm64_sequoia: "4f932830c599d9ca79d2991e2048e1ba8afcc07c844685577ef5b8f38062b4f0"
    sha256 cellar: :any,                 arm64_sonoma:  "34fa8d1ea9e9984b159df5d5f3e976418318487bf6203ca62038e82392ed3f74"
    sha256 cellar: :any,                 sonoma:        "4562d2c14cda0ac450fc2403f426a7dab435791c64ad29632db4cc2d299f1a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bc82fa9e7aa73505b8ad067507dd833cec4f8191bc95fa30929de83fda48eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c98cb552cf448e49ec2c39ac19d58944fbe39b134382058f0d9c614764cbd684"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "harfbuzz"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "llvm"
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    if OS.linux?
      xvfb_pid = spawn Formula["xorg-server"].bin/"Xvfb", ":1"
      ENV["DISPLAY"] = ":1"
      sleep 10
    end

    system "git", "init", "--initial-branch=main"
    (testpath/"test.txt").write "Hello world"
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "initial commit"

    system "git", "checkout", "-b", "test"
    rm testpath/"test.txt"
    (testpath/"test.txt").write "Foo bar"
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "to-cherrypick"
    commit_hash = shell_output("git rev-parse HEAD").strip

    system "git", "switch", "main"
    system bin/"patchpal", "--commit-clean", "--no-ai", commit_hash
    assert_match commit_hash, shell_output("git log -1 --pretty=%B")
    assert_match "Foo bar", (testpath/"test.txt").read
  ensure
    Process.kill("TERM", xvfb_pid) if xvfb_pid
    Process.wait(xvfb_pid) if xvfb_pid
  end
end