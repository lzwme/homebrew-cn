class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.49.0.tar.gz"
  sha256 "9001e8bc0c6a7cf4359d8066b3845a6d9a03e212ccc5af5840fccb06ca30fa97"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90823aed543ee40e2cf78fabeb73bf8e800805de9bfb626d8d779b8b771febb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59d84548a449f798bff49933d0984511f2950b2f974aecd764b01a0d29bf781e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae2650d2479fa61f3b471c6ded355a091a6db8b33f61a964cec33120509f797a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c294407af2496440b562dada53281a44ea611d237ae1bda9f293006c20942b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "208e693591d8cb5b79150767e8d644462a7d0c4649da57c203300708ea278765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123db8c8ba9ed08f06a5febd7f15722c05d9163cdc75677fa218d236a34f3d13"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end