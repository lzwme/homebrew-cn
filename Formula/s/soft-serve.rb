class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https:github.comcharmbraceletsoft-serve"
  url "https:github.comcharmbraceletsoft-servearchiverefstagsv0.8.4.tar.gz"
  sha256 "bda96769292b74e8c3a67b8b325db735d7fc63f1f3ee7ffa3965c363bf5e7a0f"
  license "MIT"
  head "https:github.comcharmbraceletsoft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22adeda5f60af034870f2b3c0fa93ce107983a46d95e0caa6dec72642935d098"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08823daf57dbc43f71a8adbdca7ff2498eb1c1c8fc262357b15b97bd91399081"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08dbcc0ef9e3139310ca0f7744275ca8e09cb3ca92c55107af5577a48777dd7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "95a855fb9dab72847a26475a3b6dd9755820430eb99161f7258dd6285c53dba0"
    sha256 cellar: :any_skip_relocation, ventura:       "43524edfb8c69e7eb522b5c2cc226e0c2821212ebbbbd0032fd44463ae24156e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bdb546f1a8d63dccd8471483dcc261c16567a2ddb3dd6b449765060c786ba0b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin"soft"), ".cmdsoft"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}soft --version")

    pid = spawn bin"soft", "serve"
    sleep 1
    Process.kill("TERM", pid)
    assert_path_exists testpath"datasoft-serve.db"
    assert_path_exists testpath"datahooksupdate.sample"
  end
end