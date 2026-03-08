class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "be8d4a5cf752c6e8a772ca45ca11a4c84d0c1c017fa69c4b0c7d944ac7703386"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00032d9d967fb7d0a23f3f8398744d5af35f53206493b648860c482f619eb40a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00032d9d967fb7d0a23f3f8398744d5af35f53206493b648860c482f619eb40a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00032d9d967fb7d0a23f3f8398744d5af35f53206493b648860c482f619eb40a"
    sha256 cellar: :any_skip_relocation, sonoma:        "883df45bd42ac18323947ac77b08be21f9cf0fe60945c212dde59ee99dc43198"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "053a20acfe77898922e70f7778cc3943aad1c7b8640ec6891be3b2b73c468a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0da0e4fef40879c40b2c8a1cf617a1ad63b796258bc9d14eb0bca01b1f11b8e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end