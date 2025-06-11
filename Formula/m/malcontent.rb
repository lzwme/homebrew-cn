class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https:github.comchainguard-devmalcontent"
  url "https:github.comchainguard-devmalcontentarchiverefstagsv1.12.2.tar.gz"
  sha256 "1071d2ad06affba59e6d31c43a77a513dcf396877c800a814029de8b3ab6221f"
  license "Apache-2.0"
  head "https:github.comchainguard-devmalcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e9787ad29cfd1d4dab7630794067b0c793a2dea66a6f432c459bcb46fad03387"
    sha256 cellar: :any,                 arm64_sonoma:  "1e2802a6a3338fb8effa67453281837b7782e7a927bd0ff223fae1bbfb59980d"
    sha256 cellar: :any,                 arm64_ventura: "e82e78374694fafd76bba4d8394a1c0bafd948579a60fb43c71f5e0923eec67f"
    sha256 cellar: :any,                 sonoma:        "6bf9772be1cd6fd08e9d1a42f564d6006fdb9a60202b37716a72e4da36e6baca"
    sha256 cellar: :any,                 ventura:       "f0d87b396d0cf20e665e74e602834d08e49d43df426df3789355064dc34c1009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcbee901f01fe4407d9d6d695f2fcc723579b3ce93a2852da97bd8acbda3a4a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54b7533645ab4bf41250c252d0b73eec578db61e07abdebd522f4083f59286b4"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin"mal"), ".cmdmal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mal --version")

    (testpath"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}mal analyze #{testpath}")
  end
end