class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https:github.comgetsopssops"
  url "https:github.comgetsopssopsarchiverefstagsv3.9.2.tar.gz"
  sha256 "8d4cbb30afacc88b5b55d1f7c9b22c82e2dde68905dc8e797a52aafe2c96f466"
  license "MPL-2.0"
  head "https:github.comgetsopssops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7567b33797e17e0f3d1a85da1913ca11b85010a0421c1d2562252f60e51584db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7567b33797e17e0f3d1a85da1913ca11b85010a0421c1d2562252f60e51584db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7567b33797e17e0f3d1a85da1913ca11b85010a0421c1d2562252f60e51584db"
    sha256 cellar: :any_skip_relocation, sonoma:        "5492d1bd65d75f608a2695dbd2b665a6fd28b83d12594ce3b13e8bf5836d4e5d"
    sha256 cellar: :any_skip_relocation, ventura:       "5492d1bd65d75f608a2695dbd2b665a6fd28b83d12594ce3b13e8bf5836d4e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c0529de1eeb34a8a7b489a760c813c72d1071ec2a0cd05452bdb05ea5b3c39e"
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "tidy"

    ldflags = "-s -w -X github.comgetsopssopsv3version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdsops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}sops #{pkgshare}example.yaml 2>&1", 128)
  end
end