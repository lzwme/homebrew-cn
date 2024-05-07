class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.77.3.tar.gz"
  sha256 "2ebb490497ca726bf5945c56f5b92deda52d1469f70989ea0c4bb43e802906a5"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a75b08fe716ef376668ad89d9c7884135d6581290c9d1c3c4b3bde362c234f15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43949f58ed390f0d39f6bc5cf199205206019a6ce2646c2e863e3b2662c7cf95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f5ba3bdb8d6db83c0e1684a23a70e2de1c1d16c5a6d0dda0aa7138237906654"
    sha256 cellar: :any_skip_relocation, sonoma:         "754b7a6a24bf9eb29cc4eeb13b96ed303befeaeecbeee8c0cf64c80c12ad5062"
    sha256 cellar: :any_skip_relocation, ventura:        "47f80ab124f903ccafd5f7d4d08972e39335946368ac7fedd588f383d9700482"
    sha256 cellar: :any_skip_relocation, monterey:       "ac705f737aae58b1b08909e11630b469d694e40a0e90dd4e893df663b7231e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d14c069a34fdad9af5e9b1d8a51636439ae3ea3ef97e481ea353bdb7c3046ebf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end