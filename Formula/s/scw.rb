class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://ghproxy.com/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "31affac69ab3e27282fa9e2533ba7499232651b6a893534ceb80e14b8534c5ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59b3a7a6c73bb2b3356957f55c831f35c5d6907eefc58dc88af9fb96c07667da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9139a7ce077d84041f23cbd96461f3afc601ca72c99732245eedaea29ea4e79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca66e0059fe9d97fe5bc63e254348ceef6cb9d323230569ac89412ae7bbaa27"
    sha256 cellar: :any_skip_relocation, sonoma:         "418fef676bacf78b06caa39f97b63cd1ed322e5416e8987b0732ec34447f2da6"
    sha256 cellar: :any_skip_relocation, ventura:        "ef92faf1e924f00092a6e18a8342b1343c4b1d80aac48302efa4efa6bfef9152"
    sha256 cellar: :any_skip_relocation, monterey:       "5c755feab7b5bac511dd186758a04feb3bb3335a37b3b714139f36aa44246045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc71c813b478c54260e7b6579b83a094e759b6ffc799ad4b8c87d509490f40bd"
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