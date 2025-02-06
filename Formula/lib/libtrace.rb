class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https:github.comLibtraceTeamlibtrace"
  url "https:github.comLibtraceTeamlibtracearchiverefstags4.0.27-1.tar.gz"
  version "4.0.27"
  sha256 "68441ff9152f4c52f094480320417b2a157dd8e7f3532a619ec5bb890ea949bf"
  license all_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:[.-]\d+)+)$i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub(-1$, "") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a7c74fac12db97c5ddad96cacba7901ae88cafa728c6cb1557df8c8f0aae276"
    sha256 cellar: :any,                 arm64_sonoma:  "c9fae135e6826672a3b3bcabd0231976a27d3eb04e8f9c4bfed4bcca0c99a4f5"
    sha256 cellar: :any,                 arm64_ventura: "51768fc77d5e92cfe1b0607af347803d1cc4de47908a542515461bb8183591c4"
    sha256 cellar: :any,                 sonoma:        "3bd010c9886d69bd850ef700f828f113f4ebff75e472ef53ce7dee354ee65a1d"
    sha256 cellar: :any,                 ventura:       "0f0002e2f6d990f2a7c8816416ed00043b296c71bb0c1b659c7ecb20a53de07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b623ca7363e69a6395643acec0e2e87e10b53362b3cd5c4aaff9e8459d67fda"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "wandio"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  resource "homebrew-8021x.pcap" do
    url "https:github.comLibtraceTeamlibtraceraw9e82eabc39bc491c74cc4215d7eda5f07b85a8f5testtraces8021x.pcap"
    sha256 "aa036e997d7bec2fa3d387e3ad669eba461036b9a89b79dcf63017a2c4dac725"
  end

  def install
    system ".bootstrap.sh"
    system ".configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <libtrace.h>
      #include <inttypes.h>
      #include <stdio.h>
      #include <getopt.h>
      #include <stdlib.h>
      #include <string.h>

      double lastts = 0.0;
      uint64_t v4_packets=0;
      uint64_t v6_packets=0;
      uint64_t udp_packets=0;
      uint64_t tcp_packets=0;
      uint64_t icmp_packets=0;
      uint64_t ok_packets=0;

      static void per_packet(libtrace_packet_t *packet)
      {
        * Packet data *
        uint32_t remaining;
        * L3 data *
        void *l3;
        uint16_t ethertype;
        * Transport data *
        void *transport;
        uint8_t proto;
        * Payload data *
        void *payload;

        if (lastts < 1)
          lastts = trace_get_seconds(packet);

        if (lastts+1.0 < trace_get_seconds(packet)) {
          ++lastts;
          printf("%.03f,",lastts);
          printf("%"PRIu64",%"PRIu64",",v4_packets,v6_packets);
          printf("%"PRIu64",%"PRIu64",%"PRIu64,icmp_packets,tcp_packets,udp_packets);
          printf("\\n");
          v4_packets=v6_packets=0;
          icmp_packets=tcp_packets=udp_packets=0;
        }

        l3 = trace_get_layer3(packet,&ethertype,&remaining);

        if (!l3)
          * Probable ARP or something *
          return;

        * Get the UDPTCPICMP header from the IPv4_packetsIPv6_packets packet *
        switch (ethertype) {
          case 0x0800:
            transport = trace_get_payload_from_ip(
                (libtrace_ip_t*)l3,
                &proto,
                &remaining);
            if (!transport)
              return;
            ++v4_packets;
            break;
          case 0x86DD:
            transport = trace_get_payload_from_ip6(
                (libtrace_ip6_t*)l3,
                &proto,
                &remaining);
            if (!transport)
              return;
            ++v6_packets;
            break;
          default:
            return;
        }

        * Parse the udp_packetstcp_packetsicmp_packets payload *
        switch(proto) {
          case 1:
            ++icmp_packets;
            return;
          case 6:
            payload = trace_get_payload_from_tcp(
                (libtrace_tcp_t*)transport,
                &remaining);
            if (!payload)
              return;

            ++tcp_packets;
            break;
          case 17:

            payload = trace_get_payload_from_udp(
                (libtrace_udp_t*)transport,
                &remaining);
            if (!payload)
              return;
            ++udp_packets;
            break;
          default:
            return;
        }
        ++ok_packets;
      }

      static void usage(char *argv0)
      {
        fprintf(stderr,"usage: %s [ --filter | -f bpfexp ]  [ --snaplen | -s snap ]\\n\\t\\t[ --promisc | -p flag] [ --help | -h ] [ --libtrace-help | -H ] libtraceuri...\\n",argv0);
      }

      int main(int argc, char *argv[])
      {
        libtrace_t *trace;
        libtrace_packet_t *packet;
        libtrace_filter_t *filter=NULL;
        int snaplen=-1;
        int promisc=-1;

        while(1) {
          int option_index;
          struct option long_options[] = {
            { "filter",   1, 0, 'f' },
            { "snaplen",    1, 0, 's' },
            { "promisc",    1, 0, 'p' },
            { "help",   0, 0, 'h' },
            { "libtrace-help",  0, 0, 'H' },
            { NULL,     0, 0, 0 }
          };

          int c= getopt_long(argc, argv, "f:s:p:hH",
              long_options, &option_index);

          if (c==-1)
            break;

          switch (c) {
            case 'f':
              filter=trace_create_filter(optarg);
              break;
            case 's':
              snaplen=atoi(optarg);
              break;
            case 'p':
              promisc=atoi(optarg);
              break;
            case 'H':
              trace_help();
              return 1;
            default:
              fprintf(stderr,"Unknown option: %c\\n",c);
              * FALL THRU *
            case 'h':
              usage(argv[0]);
              return 1;
          }
        }

        if (optind>=argc) {
          fprintf(stderr,"Missing input uri\\n");
          usage(argv[0]);
          return 1;
        }

        while (optind<argc) {
          trace = trace_create(argv[optind]);
          ++optind;

          if (trace_is_err(trace)) {
            trace_perror(trace,"Opening trace file");
            return 1;
          }

          if (snaplen>0)
            if (trace_config(trace,TRACE_OPTION_SNAPLEN,&snaplen)) {
              trace_perror(trace,"ignoring: ");
            }
          if (filter)
            if (trace_config(trace,TRACE_OPTION_FILTER,filter)) {
              trace_perror(trace,"ignoring: ");
            }
          if (promisc!=-1) {
            if (trace_config(trace,TRACE_OPTION_PROMISC,&promisc)) {
              trace_perror(trace,"ignoring: ");
            }
          }

          if (trace_start(trace)) {
            trace_perror(trace,"Starting trace");
            trace_destroy(trace);
            return 1;
          }

          packet = trace_create_packet();

          while (trace_read_packet(trace,packet)>0) {
            per_packet(packet);
          }

          trace_destroy_packet(packet);

          if (trace_is_err(trace)) {
            trace_perror(trace,"Reading packets");
          }

          trace_destroy(trace);
        }
              if (filter) {
                      trace_destroy_filter(filter);
              }
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltrace", "-o", "test"
    resource("homebrew-8021x.pcap").stage testpath
    system ".test", testpath"8021x.pcap"
  end
end