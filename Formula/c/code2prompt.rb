class Code2prompt < Formula
  desc "CLI tool to convert your codebase into a single LLM prompt"
  homepage "https:github.commufeedvhcode2prompt"
  url "https:github.commufeedvhcode2promptarchiverefstagsv2.0.0.tar.gz"
  sha256 "cf08be573e816ebe8852cd8afa6fd122f6b5c00c081ac058ada326647cf8251c"
  license "MIT"
  head "https:github.commufeedvhcode2prompt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f179492006ab58d5c5580a03a7dc21d673153aa285c07575d6e7a587202f8da"
    sha256 cellar: :any,                 arm64_sonoma:  "f0a0f2e88c04be7c391912f28028287e098a506a142647b6d0064e8858576639"
    sha256 cellar: :any,                 arm64_ventura: "b7899afb82de80cb90b75839b97a32dc5f91f2ea07ba1468df6d6350dad33df8"
    sha256 cellar: :any,                 sonoma:        "202ed5eb3d2fc4f0a9b7538d1c9c367d4444c54ef5ab5c918804ef7c6f562b35"
    sha256 cellar: :any,                 ventura:       "a62b2139d7aed8266d802ff9ff859dd5b0a8819d02d3df56db5531cc7999b28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c755d05cdb1ea38d6ea26f861d95d102e638f2161e788e25d48194af566f2e"
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