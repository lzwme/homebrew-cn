class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://ghproxy.com/https://github.com/scaleway/scaleway-cli/archive/v2.18.0.tar.gz"
  sha256 "09687beaa1ea90add9ba42a264bd107a8f9dce02a4acedfa3052300973bceede"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73607a6f4289a335d753c0f83057eb6a6a871ff962a81a87d176efb7bca2025e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73607a6f4289a335d753c0f83057eb6a6a871ff962a81a87d176efb7bca2025e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73607a6f4289a335d753c0f83057eb6a6a871ff962a81a87d176efb7bca2025e"
    sha256 cellar: :any_skip_relocation, ventura:        "a4e1ad66781661fb4c7d80eec9bce13af1fab53dbcefea9421e25b198087ccc0"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e1ad66781661fb4c7d80eec9bce13af1fab53dbcefea9421e25b198087ccc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4e1ad66781661fb4c7d80eec9bce13af1fab53dbcefea9421e25b198087ccc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66816a131bd2c83e8383954b994f469e5ffb86ca8165e1e019802ae53828d355"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end