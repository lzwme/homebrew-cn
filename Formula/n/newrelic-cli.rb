class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.77.0.tar.gz"
  sha256 "6ab7c6a7a0a518dee2bf99d568556393511aca84e4b148e6996d2b8e50e9c45e"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f1716dafd4a0bd6e39ff225ede6c4c01348d0eb80c4bab03737827c929f1cbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d9f79782aaefa9f26f17ec492e95745e8c8e5f13d4a78304ab7c4ef917bbcf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9997fef109ce98951e79a8955c4b41ab2eab73030a944c20f0a98db6e11ababa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3dc65f474454f7305fbec91b08ad8c0300c7916a24a76e600248634670cd44f"
    sha256 cellar: :any_skip_relocation, ventura:        "c7c4dd33aab4bd064903ff8116be523352b2eda3f4354966387a3ddca68640f0"
    sha256 cellar: :any_skip_relocation, monterey:       "5ad924228a74c7a7f7f69ecff90c4fb22d39eaf0e69361269ffc53a07bea65a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36358cd8e945d72a2ccaf7a778db4379e2ac5576c95c9d1af15f68c368819529"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end