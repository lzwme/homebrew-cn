class Serpl < Formula
  desc "Simple terminal UI for search and replace"
  homepage "https://github.com/yassinebridi/serpl"
  url "https://ghfast.top/https://github.com/yassinebridi/serpl/archive/refs/tags/0.3.10.tar.gz"
  sha256 "1e6c56c9ecd1024c0bbc2eae293229f9fd90af715591bb4f02be0b164f3ccfc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fcfe3ff9a9648ecd7884941d81a5a63b9c7c5cc0915668b55c6ce6d91f12a5a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58db4d5dcd16fa53100756e9ae3c0a9c18c7adf5e704aaa85656493994c13ec5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a42a6119314001710f0670dc44291ae769d9df206e14c7db38734db230f8d890"
    sha256 cellar: :any,                 arm64_linux:       "d27264ceea3f23b4a70cd29b5fea29c596d15c6637ced6356326509ff35366a9"
    sha256 cellar: :any,                 x86_64_linux:      "3d44d3a19fab2207055c15603816f02afcc9339a43a871364a5a08df6ae7aec6"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serpl --version")

    assert_match "a value is required for '--project-root <PATH>' but none was supplied",
      shell_output("#{bin}/serpl --project-root 2>&1", 2)
  end
end