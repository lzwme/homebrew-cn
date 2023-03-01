class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://ghproxy.com/https://github.com/google/go-containerregistry/archive/v0.13.0.tar.gz"
  sha256 "e5946a3cab514085278386cf9962a3591def359dbc213c06e7a53501766590fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abee3f66e8952e4cf2af806a0f2d703e002e23610acab9539df1b7e776858e86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40e50a5aa5ead8e8d9626bab79b00c2b93c167f7cd6255b352de8b9edbe39e39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4cf362e59bcc1257fbe62694f2a19940348c0fb8dbf16b84bf74953ea1d8db2"
    sha256 cellar: :any_skip_relocation, ventura:        "d17c792b19b9eb0b726df5687b79b1f1482b821008011323c7327805b21da4b2"
    sha256 cellar: :any_skip_relocation, monterey:       "7a646e540fc1921a7d8535c2a11101df5c6e05ecb4480ae23547d28260112571"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f2701308a1b810a19a1a3e147adf0072f18a77e0911ed18fa6f31cd7ac4d5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "599106f2740faec14d37d4e82b080aabd140ad108e5430856a54a9140df6356d"
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