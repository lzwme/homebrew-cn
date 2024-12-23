class Pipelight < Formula
  desc "Self-hosted, lightweight CICD pipelines for small projects via CLI"
  homepage "https:pipelight.dev"
  url "https:github.compipelightpipelightarchiverefstagsv0.10.0.tar.gz"
  sha256 "8d3862757e5e91c19c9a8528a6e98a2f86c824a4529d52c320ebc7eee0135d43"
  license "GPL-2.0-only"
  head "https:github.compipelightpipelight.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96adf14db27651fe99ec9078aa498d9ab44bbee167181e28ef3f2e618936983f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21227916e98d2e5abc4efc7ae84c4eef1e19ee0cdc5fb80e9e72bbed7fd14253"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41fa397d45714a97f19f9b0993a12b064cd66052751fa8a9c1d9bd78b9f1cdfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9538539a6b67e33d5db97fc883d0833661b6995b6174e380759beb75b732fe2d"
    sha256 cellar: :any_skip_relocation, ventura:       "49ac565299b8f5d08ead5b65eb27548b4c2fe993bf2121115e3c13efb5267fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46123e6bfd89ff6ad47c942c4c8ced3b26ba3dabe51969e42419c99c16804b40"
  end

  depends_on "rust" => :build

  def install
    # upstream pr ref, https:github.compipelightpipelightpull33
    system "cargo", "update", "-p", "libc"

    inreplace "cliCargo.toml", "version = \"0.0.0\"", "version = \"#{version}\"" if build.stable?

    system "cargo", "install", *std_cargo_args(path: "pipelight")

    bash_completion.install "autocompletionpipelight.bash" => "pipelight"
    fish_completion.install "autocompletionpipelight.fish"
    zsh_completion.install "autocompletion_pipelight"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pipelight --version")

    # opthomebrewCellarpipelight0.10.0binpipelight init --template yaml
    system bin"pipelight", "init", "--template", "yaml"
    assert_equal <<~YAML, (testpath"pipelight.yaml").read
      pipelines:
        - name: example
          steps:
            - name: first
              commands:
                - ls
                - pwd
            - name: second
              commands:
                - ls
                - pwd
    YAML

    assert_match "example", shell_output("#{bin}pipelight ls")

    system bin"pipelight", "run", "example"
  end
end