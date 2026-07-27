class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://gitlab.com/shackra/goimapnotify"
  url "https://gitlab.com/shackra/goimapnotify/-/archive/2.5.7/goimapnotify-2.5.7.tar.bz2"
  sha256 "26475e54d7834ca6778737494d69477e7a13a0296195af7fb4f69472b8839bb6"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/shackra/goimapnotify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "679141c81158f5612ec571d8ffcc69b2482afedadd5ba7ff4b74ec17070dd5d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "679141c81158f5612ec571d8ffcc69b2482afedadd5ba7ff4b74ec17070dd5d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "679141c81158f5612ec571d8ffcc69b2482afedadd5ba7ff4b74ec17070dd5d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff3a898b6fd76c5fffc9b9c368936d8e15968fb34100e86c4ac602165b12262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f1e8aba002953b3cf81b2ac5c816efe3ebf8e2f331929e6602b12164f814cdb"
    sha256 cellar: :any,                 x86_64_linux:  "b73e1ade1cbce3ab294da429870fe48b14cfacce489492752eaf3b53a8366234"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.gittag=#{version}"), "./cmd/goimapnotify"
  end

  service do
    run [opt_bin/"goimapnotify"]
    keep_alive true
    log_path var/"log/goimapnotify.log"
    error_log_path var/"log/goimapnotify.log"
  end

  test do
    (testpath/"config.yml").write <<~YAML
      configurations:
        - username: test@example.com
    YAML

    output = shell_output("#{bin}/goimapnotify -conf #{testpath}/config.yml 2>&1", 1)
    assert_match "tag #{version}", output
    assert_match "empty or have invalid configuration format", output
  end
end