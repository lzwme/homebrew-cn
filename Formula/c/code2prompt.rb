class Code2prompt < Formula
  desc "CLI tool to convert your codebase into a single LLM prompt"
  homepage "https:github.commufeedvhcode2prompt"
  url "https:github.commufeedvhcode2promptarchiverefstagsv2.1.0.tar.gz"
  sha256 "f1864a5d9e8e23270e0ef17ec56d709dad0ba4134950cf72b310a63b548b5c2d"
  license "MIT"
  head "https:github.commufeedvhcode2prompt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1dc66e144a2dfeff7dda031cc0d16632d282119d736b0993cf50a7a5b005b67"
    sha256 cellar: :any,                 arm64_sonoma:  "8c40b3ece87ed6c35ea242579e781faf9fd20686a94b7fe432abe3a13ab32736"
    sha256 cellar: :any,                 arm64_ventura: "db469773a77d1e02a4ddb2a95a451eb8615aca0ef682e40bd6101b789887f999"
    sha256 cellar: :any,                 sonoma:        "20723e1b0317cc845d3a485f4bc117e2555d302f897e91711bf15f463da9af09"
    sha256 cellar: :any,                 ventura:       "2dd202385ad7dd7ae77789cd49776a2ca7156f99040d26fcb5fc926bde3bb57b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "602d1c3a1a724b30a16c84e774aaf3f13f948d63a093ff4578391d3e6c475c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9344860f7461bba1dae2a42a0d29c35279a5fde630d1dc1589137de249cdcdfa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utilslinkage"

    assert_match version.to_s, shell_output("#{bin}code2prompt --version")

    (testpath"test.py").write <<~PYTHON
      def hello_world():
          print("Hello, world!")
    PYTHON

    output = shell_output("#{bin}code2prompt --no-clipboard --json test.py")
    assert_match "ChatGPT models, text-embedding-ada-002", JSON.parse(output)["model_info"]

    [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"code2prompt", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end