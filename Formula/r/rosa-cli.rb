class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https:www.openshift.comproductsamazon-openshift"
  url "https:github.comopenshiftrosaarchiverefstagsv1.2.44.tar.gz"
  sha256 "481d2951190385f5131565c864f2f1c9187fc87bc4c45f46e603186661d0e6a2"
  license "Apache-2.0"
  head "https:github.comopenshiftrosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "976220f7de4543f654886585cbda2f7ee1ef42d633e752f39268162ba55ccd16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb6c1600c989a5b2e5635aac61060484553b98fc762326bad14353e32addead7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "228b58d014d44d2d62f124fbcde783be289b43fa004875383bc6a2bd8ca72391"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0c896b155a964e0bc4b93090eecf3520213516d5e8d75ef7c45422064d00f23"
    sha256 cellar: :any_skip_relocation, sonoma:         "32677990daa4fac783b63fcce8fa71e14b79d6c3ee76e086efac20d6a5d801c7"
    sha256 cellar: :any_skip_relocation, ventura:        "d264bf76c4c105b754c2baa7fc6c8d6b1a6c9146dc5af2434570acab11ead412"
    sha256 cellar: :any_skip_relocation, monterey:       "7605517e8d61488259a7e20173e3a3408ceef467224762a05a99ca8aae8a1165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8ccc154aefccc9073f966babef758607478a9c55e7aed3abc033b554c42446c"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"rosa"), ".cmdrosa"

    generate_completions_from_executable(bin"rosa", "completion", base_name: "rosa")
  end

  test do
    output = shell_output("#{bin}rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}rosa version")
  end
end