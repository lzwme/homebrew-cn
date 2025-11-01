class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/2.12.3.tar.gz"
  sha256 "d1318bc38c14f7246ed3d9e65f8c5aff682aac15c50685d59ca26fc528b8e502"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a81aa3347282e0efee9483ef42cdc43d4d8310a218d8e2808c7d2ad92d6d5feb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0851b7ad4bc30c799d3d53d16bb17526f5f38e5f5364ff420a3b396790af2018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b53c5f9dfd31b70bbc78004acae3dd05f4807e5595bd1e9ae039461163ca33da"
    sha256 cellar: :any_skip_relocation, sonoma:        "440d8bfa200e43a3c34edc3623a7de8558f303ce0dbc3447c9ed3d8a980fd4d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7a573dff3d8d2f7a03e8dc31132a40b49159c93e96afb0ab9a472d820ce11f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f95cc6cf0835546c1359905e071c222058f215d22e840f08ee67dcd03c77e9fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end