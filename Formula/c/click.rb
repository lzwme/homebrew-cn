class Click < Formula
  desc "Command-line interactive controller for Kubernetes"
  homepage "https:github.comdatabricksclick"
  url "https:github.comdatabricksclickarchiverefstagsv0.6.3.tar.gz"
  sha256 "da64d1d205b6136f318dea967eec4e9d67569be8f332875afcc6b31c9a0ef1b7"
  license "Apache-2.0"
  head "https:github.comdatabricksclick.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e987eede7eef110c096c8093ccfbf321f3835378f8a65619627eabe348e0d985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aece6aa76034deb2d8e1437d85f4e4c94195de67eb7948d19b2fc2423824808c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a828f3d797aa3aca5596984e8b8f51afdbe123c3f8e7fa4fa6e760f66a4e57e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "902ecbe1a647d12fe9fa8fc5de1e6c0336e8f4d1b979c24c71da8ee0c446ee14"
    sha256 cellar: :any_skip_relocation, sonoma:         "14315013a9e3ecd0882de00d7d5d25588e0d3ed6d098d23f61a1714e93effa39"
    sha256 cellar: :any_skip_relocation, ventura:        "b3e56cb51e4c684096a2f9c2fbc736423e2d0b38a96f6f423d0d269a149fb66b"
    sha256 cellar: :any_skip_relocation, monterey:       "db3b2aed30f0a4b6cf38f1834d3710ba051a8cce3d3e6bb2ee895b2493e4b30c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b30c2c15da3c503a541a5f751928abf68496261df9374a23c6d5dce58b9d2b8"
  end

  depends_on "rust" => :build

  uses_from_macos "expect" => :test

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir testpath"config"
    # Default state configuration file to avoid warning on startup
    (testpath"configclick.config").write <<~EOS
      ---
      namespace: ~
      context: ~
      editor: ~
      terminal: ~
    EOS

    # Fake K8s configuration
    (testpath"configconfig").write <<~EOS
      apiVersion: v1
      clusters:
        - cluster:
            insecure-skip-tls-verify: true
            server: 'https:localhost:6443'
          name: test-cluster
      contexts:
        - context:
            cluster: test-cluster
            user: test-user
          name: test-context
      current-context: test-context
      kind: Config
      preferences:
        colors: true
      users:
        - name: test-cluster
          user:
            client-certificate-data: >-
              invalid
            client-key-data: >-
              invalid
    EOS

    # This test cannot test actual K8s connectivity, but it is enough to prove click starts
    (testpath"click-test").write <<~EOS
      spawn "#{bin}click" --config_dir "#{testpath}config"
      expect "*\\[*none*\\]* *\\[*none*\\]* *\\[*none*\\]* >"
      send "quit\\r"
    EOS
    system "expect", "-f", "click-test"
  end
end