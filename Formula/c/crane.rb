class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://ghproxy.com/https://github.com/google/go-containerregistry/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "6f43e3b70d855e59303cc1c58ed0a748c3fc09ffe16db7808932fa3d75858f7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58aa6ae0a2faf0cadd0ce8f99092e09561fc147e8466d911fa75edfa59a96450"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "176749e06d5fb2cfcfbcdf8cb0345ea69699d5e23b13678e9bce4df49f8c3c23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8384a686f28be09de1ef8d6bcfcd0aa6aeae228afd204a02ed5d2d236b5d3b12"
    sha256 cellar: :any_skip_relocation, sonoma:         "a605cb45086ba08531354ac6e1df38d849b6cc2e4429a6d5a94b320e9eb16ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "22e3ea27f34e30aef8d999f763b8806c325f57580087603f3c133373b3f14426"
    sha256 cellar: :any_skip_relocation, monterey:       "f7a794c449247b9f7e82613cc4f6e7ceb796c6c58e28f1d19371513112b1269e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b289cef7b4412824828ca601d997a0efee985cd97876399688a13516006b7b32"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end