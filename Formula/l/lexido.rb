class Lexido < Formula
  desc "Innovative assistant for the command-line"
  homepage "https:github.commicr0-devlexido"
  url "https:github.commicr0-devlexidoarchiverefstagsv1.4.3.tar.gz"
  sha256 "c39cf8f93cce2480773c9099ece1d8a90c1e350cf48cad56eebea96fbc04981f"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a51785bc7e8fd96ff436d69daec2f2786a68e99ec94ce184d7e7caddcc84dd84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ca1e9acbf1452480bd301384bc7b9ac24a3465303cb8466edd0f81a2e34b5f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4956489fa0eb3d6f1df286b265bf38740151b82fefd1712e7be166f611128b2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b7dd651047def2a657583caae2eb6210bcbd838014f5d305e07f847a5e51206"
    sha256 cellar: :any_skip_relocation, ventura:        "0e2c3248e36b02b6e0fa26b5a200874d2c92d426f7675bafbda92506d69abdc5"
    sha256 cellar: :any_skip_relocation, monterey:       "38a2ef2f276bb0874d48c8ce96b783f3cc6cfe489df34cf89c81b1b9894d1001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a7971e9b13dc59d9539c08bef80de9abb3873743315c34a5a95c640a4f5a5a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Run the `lexido` command and ensure it outputs the expected error message
    output = shell_output("#{bin}lexido -l 2>&1", 1)
    assert_match "Error initializing ollama: ollama not installed on system,", output
    assert_match "please install it first using the guide on", output
    assert_match "https:github.commicr0-devlexido?tab=readme-ov-file#running-locally", output
  end
end