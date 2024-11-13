class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https:github.comsharkdphyperfine"
  url "https:github.comsharkdphyperfinearchiverefstagsv1.19.0.tar.gz"
  sha256 "d1c782a54b9ebcdc1dedf8356a25ee11e11099a664a7d9413fdd3742138fa140"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsharkdphyperfine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1052ba49bea61d5067ddc7ed874e113f38861db6f803cbadd01ca76e2a669729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce2bd2477b8ed96d4a450e5cb8461196b9141c974db2ee4ce36c967bd73e0186"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de9596f8420130df8e51d30ac2c17f72b904dec69366ec085372f65020947640"
    sha256 cellar: :any_skip_relocation, sonoma:        "52bfaad54da195297be6f729d4b90428be28e8476be776ee936306333e09de94"
    sha256 cellar: :any_skip_relocation, ventura:       "22de2528600a8983011899f46ad1fe9b4c5e870f050ad3a3f31c5dd56bc029e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d248b05f6f1c95ab9a9d987710b68483da51a8ef8684fb39567fa83d4298f681"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "dochyperfine.1"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https:github.comclap-rsclapissues5190
    (share"bash-completioncompletions").install "hyperfine.bash" => "hyperfine"
  end

  test do
    output = shell_output("#{bin}hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end