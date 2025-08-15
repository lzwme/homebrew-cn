class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://ghfast.top/https://github.com/sigoden/dufs/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "940fe767946699bdecb9be24700f9abe5a08e913ff7edf1a5388c8a540ff1e0f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0edcebb39068990a91197db2a95df34fe1b48968b742f986bd1fcacec8d70e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "930031d9b9eac29e67d7991f733af0842bf53fb5e7aeae9b0c74c8551c6fde91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "569378659e49b342769be41682244b5a066b303fc275f0732104a830d0d9f2c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7dde31dd005e421d16a8e63c2cbf04e64246a2a7858a229347498dfba525039"
    sha256 cellar: :any_skip_relocation, ventura:       "e6dd5bfc26e4e2a2ee56fd630273db27d1745a026cdf7343882d1fd88ba19fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "091a3e212dbaee7f53b10524916c91fc7214b5d3309aea9ef954e3a0b6e0e7b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85339ad20995152e2b93ec3a1ac1d4318d2fa18d0488d80233ac3b1ccc2a9ef9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dufs", "--completions")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"dufs", bin.to_s, "-b", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"dufs").read
      assert_equal read, shell_output("curl localhost:#{port}/dufs")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end