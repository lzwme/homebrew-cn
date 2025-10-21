class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "8db8b509ef8277f3879154df14dffe04c5ba882df4a34ef4e037eebd9f9403c8"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d442226bf33808372f664a1b88cbca74b700e60ac944707563b0fca638bc0f0e"
    sha256 cellar: :any,                 arm64_sequoia: "796afabc28da3b1208b9bc91efb13ec66113bb8a018c8e77e7ece056f2cb2fc2"
    sha256 cellar: :any,                 arm64_sonoma:  "ebb133e26bade87e3473d687ecedfbc7979dee4788a9ab6034d64ddaace6d9c5"
    sha256 cellar: :any,                 sonoma:        "dbfc44baf7277e095366f8985d14256dc16230176c65b078d271d6120a8d87ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "861374fdc353ee68f71b3f4126b63d6c38295df0aa23e808ccde57a4ecccc211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad5699889baf3d917607ac526672e78707d1bd633fd66074af54d7a052097b2"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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