class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://ghproxy.com/https://github.com/google/go-containerregistry/archive/v0.16.1.tar.gz"
  sha256 "6b8d41175fda7497a90eb89a9b30d8291b418e1f9e524ae094439c9887fb06ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6828ee0cb41f068f187165190773acff3186256b0ee2290b2613d9744a6edfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6828ee0cb41f068f187165190773acff3186256b0ee2290b2613d9744a6edfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6828ee0cb41f068f187165190773acff3186256b0ee2290b2613d9744a6edfb"
    sha256 cellar: :any_skip_relocation, ventura:        "b860bc0d7a2d0d77c5b9324ad62d5a0d5976c43799d7c03cff2c02764f465cde"
    sha256 cellar: :any_skip_relocation, monterey:       "b860bc0d7a2d0d77c5b9324ad62d5a0d5976c43799d7c03cff2c02764f465cde"
    sha256 cellar: :any_skip_relocation, big_sur:        "b860bc0d7a2d0d77c5b9324ad62d5a0d5976c43799d7c03cff2c02764f465cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58f3bf5d0e0867a13a3bfde7e965113ac54afc72bc1422727b457858ab498909"
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