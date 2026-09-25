class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://ghfast.top/https://github.com/spinel-coop/rv/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "a88bf0edc2ddb14c90e59a845fc8c9b3b26af236764fdfbef368bb0b33a395ea"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73246abb08121f85ab205ec46f2f834fae552aacc55b327c274491c7e101f343"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bab99d390f461f06c01534f6304e8d01bf4f5b125df3a77380a94f3df7b29594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb556da911b788f595e646435285df25f5c58a18c7e3713159ccd106c4a581e6"
    sha256 cellar: :any,                 arm64_linux:       "f014372e63b43c5c78bc6b737b403b67fd6ac6edd1f3659fe46b337e09879f5b"
    sha256 cellar: :any,                 x86_64_linux:      "706d566c8bb71311d85635f2ce2084d1514d3ddc4589c5bf5ba52e390a981393"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_macos do
    depends_on macos: :sonoma
  end

  conflicts_with "rv-r", because: "both install `rv` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
    generate_completions_from_executable(bin/"rv", "shell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list --installed-only 2>&1")
    (testpath/"hello.rb").write <<~RUBY
      puts "Homebrew"
    RUBY
    assert_match "Homebrew", shell_output("#{bin}/rv run --ruby 3.4.5 hello.rb")
  end
end