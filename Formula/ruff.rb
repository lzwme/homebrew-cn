class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.284.tar.gz"
  sha256 "841e55268ffd5d3d3113d5f32590f46a974aab5811736ed01542340f80a42901"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a38b9d6c7e51e3d773d4dfc2c1f7ae3fafe000cd3aab8879015fa99c44c0d6f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5cd314820b5fc3378700c6c0bbadc44504fe83daa2a971865e3c72244792f89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a3b83bc2a7366556d375badb195f38759a9ada5b0d478604514ed8a81aa1700"
    sha256 cellar: :any_skip_relocation, ventura:        "99060db26269c499bda7a7838dc8eac5711ff8cb6b957b7071b5a4d276fa8a65"
    sha256 cellar: :any_skip_relocation, monterey:       "8e6da1d396508af0147c4d187082e1043180f1d56aabd79f270fa565615442c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7d2ac7ff8aac4fd93b78ca072e3bb236eb2bfd4c6ec1477a0654eaed2b27c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9093a633a290039712e04180a29704c86f6fa245934f13f8f68341862599914a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end