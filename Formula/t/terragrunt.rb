class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.81.3.tar.gz"
  sha256 "fab97723c2bb8391d8cde3745ff068b09e5a5b4ffe7273283cc9dc844b015803"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66208b8c713d48f42cbcdb460dc89946b049db5810ede768fd90018f1c95e92e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66208b8c713d48f42cbcdb460dc89946b049db5810ede768fd90018f1c95e92e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66208b8c713d48f42cbcdb460dc89946b049db5810ede768fd90018f1c95e92e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe17f8465a8a63af0188863a099e690bf4d340744fca17f04f7bfef24037e912"
    sha256 cellar: :any_skip_relocation, ventura:       "fe17f8465a8a63af0188863a099e690bf4d340744fca17f04f7bfef24037e912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e6ceb9fe10b2d5bdbaa33856ce99ba1f7200aaadbdd61c11e81d145e8b6dd7c"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end