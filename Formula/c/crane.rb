class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https:github.comgooglego-containerregistry"
  url "https:github.comgooglego-containerregistryarchiverefstagsv0.20.0.tar.gz"
  sha256 "56264dcd9078e9be0ec469d30dbd937b1b706fd7c34df91ce82bacd95986ff6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b980af08449a87307e5fdcf5caa1feadc9a267e3f58dc7f31cc02c72d087bfa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6d36d5d9981db420a60ca9da249a998714bc257525d8dac0cc01e0901ca7f5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5574b4141cd0164af9cdb9244cc1d1ad2b2a1570e2709938d40ff2509116ad93"
    sha256 cellar: :any_skip_relocation, sonoma:         "48093300a8265ef2993d85f02ea20a5fc8a5f8ee90899c77eee98134e4da2109"
    sha256 cellar: :any_skip_relocation, ventura:        "81eda5b809bb66342c103a927c6a311f3dee3d15bdd82df6d5958967334688b4"
    sha256 cellar: :any_skip_relocation, monterey:       "4cd7a9012fe2a8b71f2699b9e54e89ec60b04315e2bded121ff580053b060539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c55086306f6d342270662e9a6836e03183181f40ea244e914a7887c7b894877a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgooglego-containerregistrycmdcranecmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdcrane"

    generate_completions_from_executable(bin"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}crane manifest gcr.iogo-containerregistrycrane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end