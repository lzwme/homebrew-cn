class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https:temporal.io"
  url "https:github.comtemporaliocliarchiverefstagsv0.10.7.tar.gz"
  sha256 "23ec436df5bb5fcd3ad25ace1ba5fc5af9666f28426d47d8a64a7bdf660b069a"
  license "MIT"
  head "https:github.comtemporaliocli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d72f341da67dc3e0fcb505e0b72b6ef7110e630cddcb6c4c5972b0b049e58091"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7abbc23d0604dcfedbb9ab28d0887cae955440dddf44e61d593a0c5aebe10c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cdc95bc0e32579b49130f3e1d8115aca6c70cc11b9e486b02f355534d40eae2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c459c0cfd83b0a658333cfad590109ceba1d5b13c2dd50ab21c33e001f582685"
    sha256 cellar: :any_skip_relocation, ventura:        "5b72911c7e38e111af94a9dcaaab13c2d17ac0984ba122101749ca6cc992e8d1"
    sha256 cellar: :any_skip_relocation, monterey:       "0287c9f4559aef8659550a7fce7520371deb8c9546ff8208e0892f15a88e693d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1065c15d9da50914e376d5cba9b0bd5c2593aedabc70ff8bf903ecc195e681"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtemporaliocliheaders.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdtemporal"
    generate_completions_from_executable(bin"temporal", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end