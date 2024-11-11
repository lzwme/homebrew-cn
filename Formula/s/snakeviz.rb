class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/04/06/82f56563b16d33c2586ac2615a3034a83a4ff1969b84c8d79339e5d07d73/snakeviz-2.2.2.tar.gz"
  sha256 "08028c6f8e34a032ff14757a38424770abb8662fb2818985aeea0d9bc13a7d83"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf83d69854f81ea7e49d0f3294ec95079e24c6317a2718eb87769340198e362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f4b73381a93267d81356694340892c6f5ef02359a803a16e0b4256362460d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83d6771ad3a542629ed79fad73e68f2c2151c17acf283b3b4e6ea5b3e20d715c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e10a49c565b9ea48948cbc1e6c9c6b84839ece560f6d3a2645ae91966cc31c3"
    sha256 cellar: :any_skip_relocation, ventura:       "304463f63c64d33eb80edf14e447da50d9c3b2d737f4c2a06b48af5d26337cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a406605762652107a661caf2d544b4bddb3372f534e657d75e1613defd105090"
  end

  depends_on "python@3.13"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/ee/66/398ac7167f1c7835406888a386f6d0d26ee5dbf197d8a571300be57662d3/tornado-6.4.1.tar.gz"
    sha256 "92d3ab53183d8c50f8204a51e6f91d18a15d5ef261e84d452800d4ff6fc504e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "cgi"
    system bin/"snakeviz", "--version"
    system "python3.13", "-m", "cProfile", "-o", "output.prof", "-m", "cProfile"

    port = free_port

    output_file = testpath/"output.prof"

    pid = fork do
      exec bin/"snakeviz", "--port", port.to_s, "--server", output_file
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/snakeviz/#{CGI.escape output_file}")
    assert_match "cProfile", output
  ensure
    Process.kill("HUP", pid)
  end
end