class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "d5d3f363756efb69abe83d1be60b739b5e69f26e0a18a136fff0c405d35460f3"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89be8c330003966b5c250136950a9322fcbbb7b9651034d3d36f39cb4a46ce90"
    sha256 cellar: :any,                 arm64_sonoma:  "fcbbdfb32abdf5885fea9f5e04e09884fa827e9e8873048966e11e66efa82a63"
    sha256 cellar: :any,                 arm64_ventura: "6b7abd3c1f54cfa6904b4d4e83097493a027ea72b9ad4cb319880358d38c78eb"
    sha256 cellar: :any,                 sonoma:        "70cc4198e034d42b909449975fe0059817f5eb1c433b39175974992e9e4bc41f"
    sha256 cellar: :any,                 ventura:       "91a2ab5af0bc45b8357df6a2df47ce16f4795d9e4165079e46ca130472d79c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e54ce0529737b4e674e5a9b2cca8858f57365c0ded6b093adebfc9f22b020a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f1b6d30c68b147dfd0a7a90cad7dd78faa5cf5a1de127b1d2f66963fb2c9ca"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end