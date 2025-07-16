class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.23.4.tar.gz"
  sha256 "818e07edb59b85a4393ad499aeb9b6c665e62d98b5d8104c1d481e78feef4850"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20693efe650e3c67dbc75241511460fc75944da1609869e2954fa1b79042ac3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6244b8ca683e3932dbca268a0245a3a4cfaebc93f0c4e3c7860940ddf7c686"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19c09262583b936c855190b73d53a2c56ad05bef81a6f793613152c8092150f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "00586d126817089a62ba390481a2cbc8d1c928f0fa4e1ff0d8efc864123d8c89"
    sha256 cellar: :any_skip_relocation, ventura:       "6f87922c9450cec8560b7bca058c16ac510b859af8cfb08e358ca4a236889bfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9634ae843987992d12593094443ab1224d937eb43cbe74b08f208569284db524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e479f17b6a08b99db6cd00c026f0a84c5aa359eebf43cb2488c2c226a10c2b4"
  end

  depends_on "go" => :build

  # purego build patch, upstream pr ref, https://github.com/coder/coder/pull/18021
  patch do
    url "https://github.com/coder/coder/commit/e3915cb199a05a21a6dd17b525068a6cb5949d65.patch?full_index=1"
    sha256 "ec0f27618f69d867ecc04c8eae648eca188e4db5b1d27e1d6bcc1bde64383cdf"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end