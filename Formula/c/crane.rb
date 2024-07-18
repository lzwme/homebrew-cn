class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https:github.comgooglego-containerregistry"
  url "https:github.comgooglego-containerregistryarchiverefstagsv0.20.1.tar.gz"
  sha256 "4bae53f34011e35ef874a60123b8ae70a5e992d804decb030479dbb888afe6d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf39e89ae75b3306071e21c3371a5d9a48fc561394ea3b3f1c243fe37931b661"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61181728326a971482ef7ceef58409ea8278986867248e8ccd00da3791ec0cc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1fd1a93d986de9ac5f796e075028016467c91746012faf2dae2b4f051ea6744"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7a76610340141832a196397161b60036e3f41fae0e596784dffcd51f69b2350"
    sha256 cellar: :any_skip_relocation, ventura:        "76a3de5187a32164717d8a6cc3a396f46e6e246102b08b91ac7077624111765b"
    sha256 cellar: :any_skip_relocation, monterey:       "49606336ef2b40e737e5ad6ea8194b36ee66a2c4f97c4522c1b569d073097421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3653f30cbca86f6c189d9c1cc70e729cdb7977098a6a85de49fc858215b41b3a"
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