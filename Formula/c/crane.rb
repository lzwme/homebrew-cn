class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://ghfast.top/https://github.com/google/go-containerregistry/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "4fb8e2b4517cbd2324c0053eb368da51c730f6514a2b51abc37676b861f7955c"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d277dd958813eb4effd94b232314cec31ceaf34e082545b09c3553687ce486ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d277dd958813eb4effd94b232314cec31ceaf34e082545b09c3553687ce486ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d277dd958813eb4effd94b232314cec31ceaf34e082545b09c3553687ce486ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0787d0f1bd29563a0573397662cde8b7786cfd489902772dcde108991a5dc3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "481b3ce1a79397faec8825f8e758b3a701945e3be78563150f0ad15a5f608be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "125167071247cc372e694166ee487415089b026b6d0295cf898f487e06481869"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", shell_parameter_format: :cobra)
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end