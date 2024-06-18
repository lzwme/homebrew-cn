class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.9.0.tar.gz"
  sha256 "a194d1720b3b7e69593a550f98f0ce47174b1ac7982defb2fed535bce02d2397"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbab9ee5e9144e6b80d10a8b8afb6ef998b2400d7698a5d11c90f4e3cabe9e81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b69c30aee9aaebdfe1da074e92d3b6cffee7370f0420fa794669ce7721db77d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adfabf573685e3ad90ca45cd89d946dc0ac76cd315df9878e072a10bb318fd52"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a62677e587c36fc1273c1a62b621abd6c68563434582c1e862f57f06d91d3b4"
    sha256 cellar: :any_skip_relocation, ventura:        "f2092a23f6ee05e39875c5e1db842b3d4bcc9ff3eafb516f0f15c00dd289b048"
    sha256 cellar: :any_skip_relocation, monterey:       "3bc6ff604f0d95acfd8701febb73f766589061915b41fdb4d7793fa7a11caf9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c31a4e8e248b875a70079e5a654d0326289ffe3e8e3d48c8b1fa7f4b072a4539"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end