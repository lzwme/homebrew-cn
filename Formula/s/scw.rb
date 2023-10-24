class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://ghproxy.com/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "203c8a2113e70ce266396cb7e2b5ee85cb1c7c09be8dc2c6ad680ac6c7c60b1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a119876a00d737dcf2ee425202bfba808f2c90df2cccfdae37bf24d62c7ab9fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "314a23b687aaf7cb9bb68eedcdf674da2a4644efd92a9ad68fd30d0df88f7e74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e28cc4be1d5b1c756a3bd696f128664ac90d16929aba7922468a770c80106b75"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8b0c921a78cda389b28ed87d0ec1e25d2d9e6f8186b09fdce810ae24aa1aaf9"
    sha256 cellar: :any_skip_relocation, ventura:        "864d4cafbb01b5b1199325de14ec6a31d522bcf0f8d4f8d3af5dd0b531abb92e"
    sha256 cellar: :any_skip_relocation, monterey:       "55d5a424d46c6cbe5cbe5743ddddef81f513bc70d5b8cca8d4ea3732d7b6da1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44790fd0d2736d43dd4b3ea2377fdffc56648d7c9cef1d84b2c6c7d67e416285"
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