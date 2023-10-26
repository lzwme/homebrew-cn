class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://ghproxy.com/https://github.com/MordechaiHadad/bob/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "05ac4956812d5cde18cf4059f0e5ce92a0556bf7a78bd487eec8670d235a4617"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b7f1cfc7f99a1d89fb25447da1188a86dea65a05588f678433f40c340100752"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f36b343d2ebcb6e64e592856143ac2c9f6ddcc30a6fb2bc22ad5ee3334031e7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afc74a19ebcb5791af1ae1e565559f0599c0f78c99e30cae7f7eef2c12bced08"
    sha256 cellar: :any_skip_relocation, sonoma:         "b28d36e21f34cf56160787d5cb337454436f614aea763e428c0e9499b76d19e9"
    sha256 cellar: :any_skip_relocation, ventura:        "60607219fc1d337f4a9753b2757f093daf99f347402b75575fc569f2e48d7691"
    sha256 cellar: :any_skip_relocation, monterey:       "cb8f0703a4384ca99d58c87dff01717fc6c9e403534b236feb52bb5f308aa79b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c905142359be287df601b380bb79984064fb84737ad1928bd18b93ce9c1eb66"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"bob", "complete")
  end

  test do
    config_file = testpath/"config.json"
    config_file.write <<~EOS
      {
        "downloads_location": "#{testpath}/.local/share/bob",
        "installation_location": "#{testpath}/.local/share/bob/nvim-bin"
      }
    EOS
    ENV["BOB_CONFIG"] = config_file
    mkdir_p "#{testpath}/.local/share/bob"
    mkdir_p "#{testpath}/.local/share/nvim-bin"

    system "#{bin}/bob", "install", "v0.9.0"
    assert_match "v0.9.0", shell_output("#{bin}/bob list")
    assert_predicate testpath/".local/share/bob/v0.9.0", :exist?
    system "#{bin}/bob", "erase"
  end
end